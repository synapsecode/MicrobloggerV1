
module.exports = (sequelize, { PRIMARYKEY, INT, STRING }) => {

    class UserModel {

        static schema = sequelize.define('user', {
            id: PRIMARYKEY(),
            created_on: INT(),
            username: STRING(),
            password: STRING(),
            name: STRING(),
            dplink: STRING(),
            description: STRING(),
            coverlink: STRING(),
            location: STRING(),
            biolink: STRING()
        });

        constructor(instance){
            this.user_reference = instance;
        }

        static create = async (data) => {
            await UserModel.schema.sync();
            let u = await UserModel.schema.findOne({ where: { username: data.username } });
            if (u === null) {
                //Create new user if does not exist
                u = await UserModel.schema.create({ ...data, created_on: Date.now(), });
            }
            return new UserModel(u);
        }

        read = async ({preview = false} = {}) => {
            let preview_info = {
                username: this.user_reference.username,
                name: this.user_reference.name,
                dplink: this.user_reference.dplink,
            }
            if (preview) {
                return preview_info;
            }

            let followers = await Promise.all((await this.user_reference.getFollowers()).map(x => new UserModel(x)));
            let following = await Promise.all((await this.user_reference.getFollowing()).map(x => new UserModel(x)));

            preview_info = {
                ...preview_info,
                coverlink: this.user_reference.coverlink,
                description: this.user_reference.description,
                location: this.user_reference.location,
                biolink: this.user_reference.biolink,
                created_on: this.user_reference.created_on,
                followers: await Promise.all(followers.map(x => x.read({preview:true}))),
                following: await Promise.all(following.map(x => x.read({preview:true}))),
            }
            return preview_info
        }

        update = async (data) => {
            await UserModel.schema.sync();
            await this.user_reference.update(data);
        }

        delete = async () => {
            await UserModel.schema.sync();
            await UserModel.schema.destroy({ where: { username: this.user_reference.username } })
        }

        //----------- Actions -------------

        follow = async (u) => {
            await UserModel.schema.sync();
            if ((await this.user_reference.hasFollowing(u.user_reference))) {
                console.log('user already follows ' + u.user_reference.username);
                return;
            }
            await this.user_reference.addFollowing(u.user_reference);
        }

        unfollow = async (u) => {
            await UserModel.schema.sync();
            if (!(await this.user_reference.hasFollowing(u.user_reference))) {
                console.log('user does not follow ' + u.user_reference.username);
                return;
            }
            await this.user_reference.removeFollowing(u.user_reference);
        }

        remove_follower = async (u) => {
            await UserModel.schema.sync();
            if (!(await this.user_reference.hasFollowers(u.user_reference))) {
                console.log(u.user_reference.username + 'does not follow user')
                return;
            }
            await this.user_reference.removeFollowers(u.user_reference);
        }

    }

    return UserModel;
}
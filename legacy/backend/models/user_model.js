const { UserSchema } = require('../database')

class UserModel {

    static fromUser = async (obj) => {
        return await UserModel.create({
            username: obj.username,
            password: obj.password,
            name: obj.name,
            display_picture_link: obj.display_picture_link,
            coverlink: obj.coverlink,
            description: obj.description,
            location: obj.location,
            biolink: obj.biolink,
            created_on: obj.created_on
        });
    }

    static create = async (data) => {
        await UserSchema.sync();
        let u = await UserSchema.findOne({ where: { username: data.username } });
        if (u === null) {
            //Create new user if does not exist
            u = await UserSchema.create({ ...data, created_on: Date.now(), }).catch((err) => {
                console.log(err);
            });
        }
        //acts as the constructor
        let model = new UserModel();
        model.user_reference = u;
        model.data = data;
        return model;
    }

    follow = async (u) => {
        await UserSchema.sync();
        if ((await this.user_reference.hasFollowers(u.user_reference))) {
            console.log('user already follows ' + u.user_reference.username);
            return;
        }
        await this.user_reference.addFollower(u.user_reference);
    }

    unfollow = async (u) => {
        await UserSchema.sync();
        if (!(await this.user_reference.hasFollowers(u.user_reference))) {
            console.log('user does not follow ' + u.user_reference.username);
            return;
        }
        await this.user_reference.removeFollowers(u.user_reference);
    }

    remove_follower = async (u) => {
        await UserSchema.sync();
        if (!(await this.user_reference.hasFollowing(u.user_reference))) {
            res.send(u.user_reference.username + 'does not follow user')
            return;
        }
        await this.user_reference.removeFollowing(u.user_reference);
    }

    followers = async () => {
        return await this.user_reference.getFollowers();
    }

    following = async () => {
        return await this.user_reference.getFollowing();
    }

    json = async (preview = false) => {
        let preview_info = {
            username: this.user_reference.username,
            name: this.user_reference.name,
            display_picture_link: this.user_reference.display_picture_link,
        }
        if (preview) {
            return preview_info;
        }
        preview_info =  {
            ...preview_info,
            coverlink: this.user_reference.coverlink,
            description: this.user_reference.description,
            location: this.user_reference.location,
            biolink: this.user_reference.biolink,
            created_on: this.user_reference.created_on,
            // followers: (await this.followers()).map(x => UserModel.fromUser(x).then(y => y.json(preview=false)))
            // following: await this.following()
        }

//         .then(x => UserModel.fromUser(x).then(y => y.json(preview=true)))
// .then(x => UserModel.fromUser(x).then(y => y.json(preview=true)))
        return preview_info;
    }

    update = async (data) => {

    }

    delete = async () => {
        await UserSchema.sync()
        await UserSchema.destroy({ where: { username: this.user_reference.username } });
        //Destroy any other references to Users
    }
}

module.exports = UserModel

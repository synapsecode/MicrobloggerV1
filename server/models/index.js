module.exports = (sequelize, Sequelize) => {

    //-------- Types ---------------
    const PRIMARYKEY = () => {
        return {
            type: Sequelize.INTEGER,
            autoIncrement: true,
            primaryKey: true,
            allowNull: false,
        }
    };
    const INT = () => {
        return {
            type: Sequelize.INTEGER,
            allowNull: false,
        }
    };
    const STRING = () => {
        return {
            type: Sequelize.STRING,
            allowNull: false,
        };
    };
    //---------Types-------------

    const UserModel = require('./user_model')(sequelize, { PRIMARYKEY, INT, STRING });

    //------------- < Follow Feature >---------------
    UserModel.schema.belongsToMany(UserModel.schema, {
        through: 'FollowTable',
        as: 'followers',
        foreignKey: 'follower_id',
        otherKey: 'following_id'
    })
    UserModel.schema.belongsToMany(UserModel.schema, {
        through: 'FollowTable',
        as: 'following',
        foreignKey: 'following_id',
        otherKey: 'follower_id'
    })
    console.log('created FollowTable association')
    //------------------------------------------------

    return {
        UserModel,
    }
}
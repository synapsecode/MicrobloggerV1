module.exports = (sequelize, Sequelize) => {
    const {import_model} = require('./helpers')(sequelize, Sequelize);
    
    //Import models
    const UserModel = import_model('user_model');
    const GenericPostModel = import_model('generic_post_model');

    //--------- Add Model dependencies to prevent circular imports ---------
    GenericPostModel.ImportedModels = {UserModel};
    //-------------------------------------------------------------------------

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
        GenericPostModel,
    }
}
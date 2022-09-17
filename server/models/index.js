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

    //----------- < Reshare 2 Reshare > ------------
    GenericPostModel.schema.hasMany(GenericPostModel.schema, {
        as: 'reshares'
    });
    GenericPostModel.schema.belongsTo(GenericPostModel.schema, {
        as: 'reshared_post'
    })
    
    //----------------------------------------------

    //----------- < PostAuthors Feature > -------------
    // UserModel.schema.belongsToMany(GenericPostModel.schema, {
    //     through: 'PostAuthorTable',
    //     as: 'authors',
    //     foreignKey: 'author_id',
    //     otherKey: 'generic_post_id'
    // })
    // GenericPostModel.schema.belongsToMany(UserModel.schema, {
    //     through: 'PostAuthorTable',
    //     as: 'posts',
    //     foreignKey: 'generic_post_id',
    //     otherKey: 'author_id'
    // })
    // console.log('created PostAuthorTable association')
    //-------------------------------------------------

    //------------< GenericPost - PostType bindings >----------------
    // GenericPostModel.schema.hasOne(MicroblogModel.schema);
    // MicroblogModel.schema.belongsTo(GenericPostModel.schema);
    // GenericPostModel.schema.hasOne(BlogModel.schema);
    // BlogModel.schema.belongsTo(GenericPostModel.schema);
    // GenericPostModel.schema.hasOne(PollModel.schema);
    // PollModel.schema.belongsTo(GenericPostModel.schema);
    // GenericPostModel.schema.hasOne(ReshareModel.schema);
    // ReshareModel.schema.belongsTo(GenericPostModel.schema);
    //---------------------------------------------------------------


    return {
        UserModel,
        GenericPostModel,
    }
}
const { Sequelize } = require("sequelize-cockroachdb");
const fs = require('fs');

//DatabaseCreation
const CONN_STR = fs.readFileSync('connstring.txt', 'utf8');
const sequelize = new Sequelize(CONN_STR, { logging: false });

//Import DBModels
const {GenericPostSchema, UserSchema} = require('./schemas')(sequelize, Sequelize);

//Implement Relationships

//User can follow other user
UserSchema.belongsToMany(UserSchema, {
    through: 'FollowTable',
    as: 'followers',
    foreignKey: 'follower_id',
    otherKey: 'following_id'
})
UserSchema.belongsToMany(UserSchema, {
    through: 'FollowTable',
    as: 'following',
    foreignKey: 'following_id',
    otherKey: 'follower_id'
})
console.log('relationships set');

//====================================================

//Export all your DBModels using this to make them accessible anywhere in the program
module.exports = {
    Sequelize,
    sequelize,
    GenericPostSchema,
    UserSchema
};
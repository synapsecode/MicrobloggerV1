const { Sequelize } = require("sequelize-cockroachdb");
const fs = require('fs');

//DatabaseCreation
const CONN_STR = fs.readFileSync('connstring.txt', 'utf8');
const sequelize = new Sequelize(CONN_STR, { logging: false });

module.exports = {
    sequelize,
    ...require('./models')(sequelize, Sequelize),
};
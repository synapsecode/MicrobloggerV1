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
    const INT = (nullable = '') => {
        return {
            type: Sequelize.INTEGER,
            allowNull: nullable === 'nullable',
        }
    };
    const STRING = (nullable = '') => {
        return {
            type: Sequelize.STRING,
            allowNull: nullable === 'nullable',
        };
    };
    const JSONTYPE = (nullable = '') => {
        return {
            type: Sequelize.JSON,
            allowNull: nullable === 'nullable',
        };
    };
     //---------Types-------------

    const import_model = (str) => {
        return require(`./${str}`)(sequelize, { PRIMARYKEY, INT, STRING, JSONTYPE });
    }

   return {import_model};
}
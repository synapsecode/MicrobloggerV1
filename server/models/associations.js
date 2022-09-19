module.exports = (sequelize, { PRIMARYKEY, INT, STRING }) => {

    class Associations {
        static postauthortable = sequelize.define('postauthors', {
            id: PRIMARYKEY(),
            generic_post_id: INT(),
            author_user_id: INT(),
        })

        static likestable = sequelize.define('likes', {
            id: PRIMARYKEY(),
            generic_post_id: INT(),
            user_id: INT(),
        })

        static resharetrackertable = sequelize.define('resharetracker', {
            id: PRIMARYKEY(),
            reshare_owner_id: INT(),
            quote_target_id: INT(),
            user_id: INT(),
        })

        static quotetrackertable = sequelize.define('quotetracker', {
            id: PRIMARYKEY(),
            quote_target_id: INT(),
            quote_owner_id: INT(),
            user_id: INT(),
        })
    }

    return Associations;
}
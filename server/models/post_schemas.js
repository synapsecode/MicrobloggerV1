module.exports = (sequelize, { PRIMARYKEY, INT, STRING }) => {

    class PostSchemas {
        static microblog = sequelize.define('microblog', {
            id: PRIMARYKEY(),
            content: STRING(),
            medialink: STRING('nullable'),
            mediaformat: STRING('nullable')
        })
        static blog = sequelize.define('blog', {
            id: PRIMARYKEY(),
            title: STRING(),
            coverlink: STRING('nullable'),
            content: JSON(),
        })
        static poll = sequelize.define('poll', {
            id: PRIMARYKEY(),
            title: STRING(),
            coverlink: STRING('nullable'),
            content: JSON(),
        })

        static getschema = (t) => {
            if (t === 'microblog')
                return PostSchemas.microblog;
            if (t === 'poll')
                return PostSchemas.poll;
            if (t === 'blog')
                return PostSchemas.blog;
        }
    }

    return PostSchemas;
}
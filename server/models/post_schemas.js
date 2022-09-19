module.exports = (sequelize, { PRIMARYKEY, INT, STRING, JSONTYPE }) => {

    class PostSchemas {
        static microblog = () => sequelize.define('microblog', {
            id: PRIMARYKEY(),
            uuid: INT(),
            text_content: STRING(),
            medialink: STRING('nullable'),
            mediaformat: STRING('nullable')
        })
        static blog = () => sequelize.define('blog', {
            id: PRIMARYKEY(),
            uuid: INT(),
            title: STRING(),
            coverlink: STRING('nullable'),
            content: JSONTYPE(),
        })
        static poll = () => sequelize.define('poll', {
            id: PRIMARYKEY(),
            uuid: INT(),
            title: STRING(),
            coverlink: STRING('nullable'),
            content: JSONTYPE(),
        })

        static getschema = (t) => {
            if (t.includes('quote')) {
                return this.getschema(t.slice(6, -1).split(',')[1]);
            } else {
                if (t === 'microblog')
                    return PostSchemas.microblog();
                if (t === 'poll')
                    return PostSchemas.poll();
                if (t === 'blog')
                    return PostSchemas.blog();
            }
        }

    }

    return PostSchemas;
}
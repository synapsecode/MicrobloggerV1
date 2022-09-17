module.exports = (sequelize, { PRIMARYKEY, INT, STRING }) => {

    const { PostSchemas } = require('./post_schemas')(sequelize, { PRIMARYKEY, INT, STRING });

    class GenericPostModel {

        static ImportedModels = {};

        static schema = sequelize.define('genericpost', {
            id: PRIMARYKEY(),
            uuid: INT(),
            created_on: INT(),
            post_type: STRING(),
            microblog_id: INT('nullable'),
            blog_id: INT('nullable'),
            poll_id: INT('nullable'),
            quote_target_id: INT('nullable')
        })

        static create = async (postdata, authors) => {
            await GenericPostModel.schema.sync();
            create_subpost = async (data, ptype) => {
                gen = async (schema, body) => {
                    await schema.sync();
                    let p = await schema.findOne({ where: { uuid: data.uuid } });
                    if (p === null) {
                        return await schema.create({
                            ...body, created_on: Date.now(),
                        });
                    }
                    return p;
                }
                switch (ptype) {
                    case 'microblog':
                        return await gen(PostSchemas.microblog, {
                            content: data.text_content,
                            medialink: data.medialink,
                            mediaformat: data.mediaformat,
                        })
                    case 'blog':
                        return await gen(PostSchemas.blog, {
                            title: data.title,
                            coverlink: data.coverlink,
                            content: data.content,
                        })
                    case 'poll':
                        return await gen(PostSchemas.poll, {
                            title: data.title,
                            content: data.content,
                        })
                }
            }

            const postassoc = (post, t) => {
                return {
                    microblog_id: (t === 'microblog') ? post.id : null,
                    blog_id: (t === 'blog') ? post.id : null,
                    poll_id: (t === 'poll') ? post.id : null,
                };
            }

            let genesis_data = {
                uuid: postdata.uuid,
                created_on: Date.now(),
                post_type: postdata.post_type,
            };

            //Check for quotes
            if (postdata.post_type.includes('quote')) {
                let pts = postdata.post_type.slice(6, -1)?.split(',') ?? [null, null];
                let [target_schema, quote_schema] = pts.map(x => PostSchemas.getschema(x))
                target_post = await target_schema.findOne({ where: { uuid: postdata.quoted_uuid } });
                let post = await create_subpost(postdata, pts[1]);
                genesis_data = {
                    ...genesis_data,
                    quote_target_id: target_post.id,
                    ...postassoc(post, pts[1]),
                }
            } else if (postdata.post_type.includes('reshare')) {
                let pt = postdata.post_type.slice(8, -1);
                let target_schema = PostSchemas.getschema(pt);
                target_post = await target_schema.findOne({ where: { uuid: postdata.quoted_uuid } });
                genesis_data = {
                    ...genesis_data,
                    quote_target_id: target_post.id,
                }
            } else {
                //Other Post types
                let post_schema = PostSchemas.getschema(postdata.post_type);
                let post = await create_subpost(postdata, post_schema);
                genesis_data = {
                    ...genesis_data,
                    ...postassoc(post, postdata.post_type),
                }
            }

            //create the generic post
            gp = await GenericPostModel.schema.create(genesis_data);

            //TODO: Link Authors & Post

            //Act as constructor
            let model = new GenericPostModel();
            model.genericpost_reference = gp;
            gp = null;
            return model;
        }

        read = async () => {
            //get data from actual post type too
        }

        update = async () => {

        }

        delete = async () => {
            await GenericPostModel.schema.sync();
            await GenericPostModel.schema.destroy({ where: { uuid: this.genericpost_reference.uuid } })
        }

        getPostAuthors = async () => {
        }

        getPostType = async () => {
            await GenericPostModel.schema.sync();
            return this.genericpost_reference.post_type;
        }

        getLikes = async () => {

        }

        getReshares = async () => {
            return {
                reshares: [],
                quotes: [],
            }
        }


    }

    return GenericPostModel;
}

/*
Notes:
    PostData = {
        uuid,
        quoted_uuid,
        text_content,
        medialink,
        mediaformat,
        title,
        coverlink,
        content (JSON),
        post_type (microblog, blog, poll, reshare<T>, quote<T,T>)
    }
    QuotedID + non-null microblog_id etc => QuotePost
    QuotedID + null microblog_id etc => Reshare
    null QuotedID = non-null microblog_id etc => Post<T>

    creating reshares:
    const x = await GenericPostModel.create({
        uuid: '2jfnfnhdgj',
        post_type: 'reshare<microblog>',
        quoted_post_id: 673858,
    })

    creating quotes:
    const x = await GenericPostModel.create({
        uuid: 'f2jfnfnhdgj',
        post_type: 'quote<microblog,microblog>',
        quoted_post_id: 594858,
        content: 'This is bullshit lmao',
        medialink: null,
        mediatype: null,
    })

    creating microblogs:
    const x = await GenericPostModel.create({
        uuid: '2jfnfnhdgj',
        post_type: 'microblog',
        content: 'This is bullshit lmao',
        medialink: null,
        mediatype: null,
    })
*/
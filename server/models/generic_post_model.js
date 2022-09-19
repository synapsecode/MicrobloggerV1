module.exports = (sequelize, { PRIMARYKEY, INT, STRING, JSONTYPE }) => {

    const PostSchemas = require('./post_schemas')(sequelize, { PRIMARYKEY, INT, STRING, JSONTYPE });
    const Associations = require('./associations')(sequelize, { PRIMARYKEY, INT, STRING, JSONTYPE });

    //helper functions
    const postassoc = (post, t) => {
        return {
            microblog_id: (t === 'microblog') ? post.id : null,
            blog_id: (t === 'blog') ? post.id : null,
            poll_id: (t === 'poll') ? post.id : null,
        };
    }

    const create_subpost = async (PostSchemas, data, ptype) => {
        const gen = async (schema, body) => {
            await schema.sync();
            let p = await schema.findOne({ where: { uuid: body.uuid } });
            if (p === null) {
                console.log('Creating Subpost', body);
                console.log('schema', schema);
                return await schema.create({
                    ...body, created_on: Date.now(),
                });
            }
            return p;
        }
        switch (ptype) {
            case 'microblog':
                return await gen(PostSchemas.microblog(), {
                    uuid: data.uuid,
                    text_content: data.text_content,
                    medialink: data.medialink,
                    mediaformat: data.mediaformat,
                })
            case 'blog':
                return await gen(PostSchemas.blog(), {
                    uuid: data.uuid,
                    title: data.title,
                    coverlink: data.coverlink,
                    content: data.content,
                })
            case 'poll':
                return await gen(PostSchemas.poll(), {
                    uuid: data.uuid,
                    title: data.title,
                    content: data.content,
                })
        }
    }

    const linkauthors = async (gp, authors) => {
        await Associations.postauthortable.sync();
        let u = await Associations.postauthortable.findOne({ where: { generic_post_id: gp.id } });
        if (u === null) {
            await Promise.all(authors.map(x => Associations.postauthortable.create({
                generic_post_id: gp.id,
                author_user_id: x.user_reference.id,
            })));
        } else {
            console.error('Already created PostAuthorBindings');
        }
    }


    class GenericPostModel {

        static ImportedModels = {};

        static schema = sequelize.define('genericpost', {
            id: PRIMARYKEY(),
            uuid: INT(),
            created_on: INT(),
            edited_on: INT('nullable'),
            post_type: STRING(),
            microblog_id: INT('nullable'),
            blog_id: INT('nullable'),
            poll_id: INT('nullable'),
            quote_target_id: INT('nullable')
        })

        constructor(instance){
            this.genericpost_reference = instance;
        }

        static create = async (postdata, authors = []) => {

            if (authors === []) {
                console.error('Post Authors not specified')
                return null;
            }

            await GenericPostModel.schema.sync();

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
                let post = await create_subpost(PostSchemas, postdata, pts[1]);
                genesis_data = {
                    ...genesis_data,
                    quote_target_id: target_post.id,
                    ...postassoc(post, pts[1]),
                }
            } else {
                //Other Post types
                let post = await create_subpost(PostSchemas, postdata, postdata.post_type);
                genesis_data = {
                    ...genesis_data,
                    ...postassoc(post, postdata.post_type),
                }
            }

            //create the generic post
            const gp = await GenericPostModel.schema.create(genesis_data);

            //linking post authors
            await linkauthors(gp, authors);

            return new GenericPostModel(gp);
        }


        read = async () => {
            await GenericPostModel.schema.sync();
            let quoted_target_id = this.genericpost_reference.quote_target_id;
            let quoted_post_data;
            if (quoted_target_id !== null) {
                let p = await GenericPostModel.schema.findOne({ where: { id: quoted_target_id } })
                let quoted_post = await new GenericPostModel(p);
                quoted_post_data = await quoted_post.read();
            }
            let schema = PostSchemas.getschema(this.genericpost_reference.post_type);
            let datapost = await schema?.findOne({ where: { uuid: this.genericpost_reference.uuid } });
            return {
                uuid: this.genericpost_reference.uuid,
                like_count: await this.get_likes({ count_only: true }),
                reshare_count: await this.get_reshares({ count_only: true }),
                //remove nulls
                post_data: Object.entries({
                    uuid: datapost?.uuid ?? null,
                    content: datapost?.content ?? null,
                    text_content: datapost?.text_content ?? null,
                    medialink: datapost?.medialink ?? null,
                    mediaformat: datapost?.mediaformat ?? null,
                    title: datapost?.title ?? null,
                    coverlink: datapost?.coverlink ?? null,
                    content: datapost?.content ?? null,
                    quoted_post_data: quoted_post_data ?? null,
                }).reduce((a, [k, v]) => (v === null ? a : (a[k] = v, a)), {}),
                created_on: this.genericpost_reference.created_on,
                post_type: this.genericpost_reference.post_type,
                edited_on: this.genericpost_reference.edited_on,
                authors: await Promise.all((await this.get_authors()).map(x => x.read({ preview: true })))
            }
        }

        update = async (data) => {
            if (this.genericpost_reference.post_type.includes('reshare')) return;
            await GenericPostModel.schema.sync();
            let schema = PostSchemas.getschema(this.genericpost_reference.post_type);
            let uuid = this.genericpost_reference.uuid;
            let datapost = await schema.findOne({ where: { uuid: uuid } });
            await datapost.update(data);
            await this.genericpost_reference.update({
                edited_on: Date.now(),
            })
        }

        delete = async () => {
            await GenericPostModel.schema.sync();
            let post_type = this.genericpost_reference.post_type;
            if (post_type.includes('quote')) {
                post_type = postdata.post_type.slice(6, -1)?.split(',')[1]; //get quote type
            }
            let post_schema = PostSchemas.getschema(post_type);
            await post_schema.destroy({ where: { generic_post_id: this.genericpost_reference.id } })
            //TODO: Destroy Internal Data table too
            await GenericPostModel.schema.destroy({ where: { id: this.genericpost_reference.id } })
        }

        //---------actions---------

        add_like = async (user) => {
            await Associations.likestable.sync();
            let dat = {
                generic_post_id: this.genericpost_reference.id,
                user_id: user.user_reference.id,
            }
            let x = await Associations.likestable.findOne({ where: dat });
            if (x === null) {
                await Associations.likestable.create(dat);
            }
        }

        remove_like = async (user) => {
            await Associations.likestable.sync();
            let dat = {
                generic_post_id: this.genericpost_reference.id,
                user_id: user.user_reference.id,
            }
            let x = await Associations.likestable.findOne({ where: dat });
            if (x) {
                await Associations.likestable.destroy({ where: dat });
            }
        }

        reshare = async (user) => {
            //Generate random UUID
            let genesis_data = {
                uuid: Math.floor(Math.random() * 111111111111),
                created_on: Date.now(),
                post_type: `reshare<${this.genericpost_reference.post_type}>`,
                quote_target_id: this.genericpost_reference.id,
            }
            //Add to reshare tracker association
            await Associations.resharetrackertable.sync();
            let r = await Associations.resharetrackertable.findOne({
                where: { 
                    user_id: user.user_reference.id, 
                    quote_target_id: this.genericpost_reference.id 
                }
            });
            let gp;
            await GenericPostModel.schema.sync();
            //handle multiresharing
            if(r === null){
                gp = await GenericPostModel.schema.create(genesis_data);
                await linkauthors(gp, [user]);
            }else{
                //get the instance of owner post
                gp = await GenericPostModel.schema.findOne({where: {id: r.reshare_owner_id}});
            }
            return new GenericPostModel(gp);
        }

        add_quote = async (user, postdata) => {
            let typ = `quote<${this.genericpost_reference.post_type},${postdata.post_type}`;
            let genesis_data = {
                uuid: Math.floor(Math.random() * 111111111111),
                created_on: Date.now(),
                post_type: typ,
            };
            let post = await create_subpost(PostSchemas, postdata, postdata.post_type);
            genesis_data = {
                ...genesis_data,
                quote_target_id: this.genericpost_reference.id,
                ...postassoc(post, postdata.post_type),
            }


            let pts = postdata.post_type.slice(6, -1)?.split(',') ?? [null, null];
            let [target_schema, quote_schema] = pts.map(x => PostSchemas.getschema(x))
            target_post = await target_schema.findOne({ where: { uuid: postdata.quoted_uuid } });
            // let post = await create_subpost(PostSchemas, postdata, pts[1]);
            genesis_data = {
                ...genesis_data,
                quote_target_id: target_post.id,
                ...postassoc(post, pts[1]),
            }
        }

        //-------------------------


        // ----------- getters ------------
        get_authors = async () => {
            await Associations.postauthortable.sync();
            await GenericPostModel.schema.sync();
            await GenericPostModel.ImportedModels.UserModel.schema.sync();
            let pats = await Associations.postauthortable.findAll({
                where: { generic_post_id: this.genericpost_reference.id }
            });
            let author_ids = pats.map(x => x.author_user_id);
            let authors_obj = await Promise.all(author_ids.map(x => GenericPostModel.ImportedModels.UserModel.schema.findOne({ where: { id: x } })));
            let authors = await Promise.all(authors_obj.map(x => new GenericPostModel.ImportedModels.UserModel(x)));
            return authors;
        }

        get_likes = async ({ count_only = false } = {}) => {
            await Associations.likestable.sync();
            let liked_user_ids = (await Associations.likestable.findAll({ where: { generic_post_id: this.genericpost_reference.id } })).map(x => x.user_id);
            if (count_only) {
                return liked_user_ids.length;
            }
            let liked_users = await Promise.all(liked_user_ids.map(x => new GenericPostModel.ImportedModels.UserModel(x)));
            return liked_users;
        }

        get_reshares = async ({ count_only = false } = {}) => {
            await GenericPostModel.schema.sync();

            let quoted_instances = await GenericPostModel.schema.findAll({
                where: {
                    quote_target_id: this.genericpost_reference.id,
                }
            });
            let reshare_instances = quoted_instances.filter(x => (x.microblog_id === null && x.blog_id === null && x.poll_id === null));
            let quote_instances = quoted_instances.filter(x => (x.microblog_id !== null || x.blog_id !== null || x.poll_id !== null));

            if (count_only) {
                return {
                    reshares: reshare_instances.length,
                    quotes: reshare_instances.length,
                }
            }

            let reshares = await Promise.all(reshare_instances.map(x => new GenericPostModel(x)));
            let quotes = await Promise.all(quote_instances.map(x => new GenericPostModel(x)));

            return {
                reshares: reshares,
                quotes: quotes,
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
        post_type (microblog, blog, poll, reshare<T>, quote<T,T>),
    }
    QuotedID + non-null microblog_id etc => QuotePost
    QuotedID + null microblog_id etc => Reshare
    null QuotedID = non-null microblog_id etc => Post<T>

    creating reshares:
    const x = await GenericPostModel.create({
        uuid: '2jfnfnhdgj',
        post_type: 'reshare<microblog>',
        quoted_post_id: 673858,
    }, [veeksha,manas])

    creating quotes:
    const x = await GenericPostModel.create({
        uuid: 'f2jfnfnhdgj',
        post_type: 'quote<microblog,microblog>',
        quoted_post_id: 594858,
        content: 'This is bullshit lmao',
        medialink: null,
        mediatype: null,
    })
    const x = await abc.add_quote(siri, {
        post_type: 'microblog'
        text_content: 'LMFAOOOO',
    })

    creating microblogs:
    const x = await GenericPostModel.create({
        uuid: '2jfnfnhdgj',
        post_type: 'microblog',
        content: 'This is bullshit lmao',
        medialink: null,
        mediatype: null,
    })






    Removed:
      reshare = async (author) => {
            //TODO: Generate a UUID on demand
            genesis_data = {
                uuid: 'UUID',
                created_on: Date.now(),
                post_type: `reshare<${this.genericpost_reference.post_type}>`,
                quote_target_id: this.genericpost_reference.id,
            }
            let gp = await GenericPostModel.schema.create(genesis_data);
            await this.__link_authors(gp, [author]);
            let model = new GenericPostModel();
            model.genericpost_reference = gp;
            return model;
        }

        quote = async (quoted_post, author) => {
            //TODO: Generate a UUID on demand
            genesis_data = {
                uuid: 'UUID',
                created_on: Date.now(),
                post_type: `quote<${this.genericpost_reference.post_type},${quoted_post.genericpost_reference.post_type}>`,
                quote_target_id: this.genericpost_reference.id,
                ...{
                    microblog_id: (quoted_post.genericpost_reference.post_type === 'microblog') ? quoted_post.genericpost_reference.id : null,
                    blog_id: (quoted_post.genericpost_reference.post_type === 'blog') ? quoted_post.genericpost_reference.id : null,
                    poll_id: (quoted_post.genericpost_reference.post_type === 'poll') ? quoted_post.genericpost_reference.id : null,
                }
            }
            let pts = postdata.post_type.slice(6, -1)?.split(',') ?? [null, null];
            let [target_schema, quote_schema] = pts.map(x => PostSchemas.getschema(x))
            target_post = await target_schema.findOne({ where: { uuid: postdata.quoted_uuid } });
            let post = await create_subpost(postdata, pts[1]);
            genesis_data = {
                ...genesis_data,
                quote_target_id: target_post.id,
                ...postassoc(post, pts[1]),
            }
        }

*/
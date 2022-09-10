module.exports = (sequelize, DataTypes) => {
    const pk = {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false,
    }

    const UserSchema = sequelize.define('user', {
        id: pk,
        created_on: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },
        username: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        password: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        name: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        display_picture_link: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        description: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        coverlink: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        location: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        biolink: {
            type: DataTypes.STRING,
            allowNull: false,
        }
    })

    const GenericPostSchema = sequelize.define('genericpost', {
        id: pk,
        created_on: {
            type: DataTypes.INTEGER,
            allowNull: false,
        }
    });

    const MicroblogSchema = sequelize.define('microblog', {
        id: pk,
        content: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        medialink: {
            type: DataTypes.STRING,
        },
        mediaformat: {
            type: DataTypes.STRING,
        },
    });

    const BlogSchema = sequelize.define('blog', {
        id: pk,
        title: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        coverlink: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        content: {
            type: DataTypes.JSON,
            allowNull: false
        }
    });

    const PollSchema = sequelize.define('poll', {
        id: pk,
        title: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        options: {
            type: DataTypes.JSON,
            allowNull: false
        }
    })


    //<--------- Association Tables ---------------->

    const PollDataAssociationSchema = sequelize.define('polldata', {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            primaryKey: true,
            allowNull: false,
        },
        poll_id: {
            type: DataTypes.INTEGER,
        },
        voter_id: {
            type: DataTypes.INTEGER,
        },
        choice_index: {
            type: DataTypes.INTEGER,
        },
    });

    const ReshareAssociationSchema = sequelize.define('reshares', {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            primaryKey: true,
            allowNull: false,
        },
        author_id: {
            type: DataTypes.INTEGER,
        },
        original_post_id: {
            type: DataTypes.INTEGER,
        },
        quote_post_id: {
            type: DataTypes.INTEGER,
        }
    })

    return {
        UserSchema,
        GenericPostSchema,
        PollSchema,
        MicroblogSchema,
        BlogSchema,
        PollDataAssociationSchema,
        ReshareAssociationSchema,
    }
}
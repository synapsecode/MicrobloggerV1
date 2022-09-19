const {UserModel, GenericPostModel} = require('./database')

async function main() {

    const manas = await UserModel.create({
        username: 'manashejmadi',
        password: '12345',
        name: 'Manas Hejmadi',
        dplink: 'https://www.google.com',
        coverlink: 'https://www.google.com',
        description: 'Methodical Rogue',
        location: 'Bengaluru',
        biolink: 'https://www.google.com',
    })

    const veeksha = await UserModel.create({
        username: 'veekshahaha',
        password: '12345',
        name: 'Veeksha M',
        dplink: 'https://www.google.com',
        coverlink: 'https://www.google.com',
        description: 'Material Gworl',
        location: 'Bengaluru',
        biolink: 'https://www.google.com',
    })

    const siri = await UserModel.create({
        username: 'sirihebbale',
        password: '12345',
        name: 'Siri Hebbale',
        dplink: 'https://www.google.com',
        coverlink: 'https://www.google.com',
        description: 'MCT',
        location: 'Bengaluru',
        biolink: 'https://www.google.com',
    })

    // console.log('Manas follows Veeksha', await manas.follow(veeksha));
    // console.log('Veeksha follows Siri', await veeksha.follow(siri))
    // console.log('Siri follows Veeksha', await siri.follow(veeksha))
    // console.log('Manas follows Siri', await manas.follow(siri));

    // console.log(await manas.read())
    // console.log(await veeksha.read())
    // console.log(await siri.read())
    
    // console.log('Siri unfollows Veeksha', await siri.unfollow(veeksha))
    // console.log('Siri removes Manas', await siri.remove_follower(manas));
    
    // console.log(await manas.read());
    // console.log(await veeksha.read())
    // console.log(await siri.read())

    // console.log('Updating Veeksha Name', await veeksha.update({name: 'Veeksha M Rao'}));
    // console.log(await veeksha.read());

    const mcbr1 = await GenericPostModel.create({
        uuid: 1848395,
        post_type: 'microblog',
        text_content: 'This is a microblog by veeksha and manas',
        medialink: 'https://www.google.com',
        mediaformat: 'genericlink',
    }, [manas,veeksha])
    //create likes
    await mcbr1.add_like(manas);
    await mcbr1.add_like(siri);

    // const mcbr2 = await GenericPostModel.create({
    //     uuid: 44638,
    //     post_type: 'microblog',
    //     text_content: 'Hello from siri',
    //     medialink: 'https://www.google.com',
    //     mediaformat: 'genericlink',
    // }, [siri])

    // edit post
    await mcbr1.update({
        text_content: 'This is an edited microblog by Manas and Veeksha'
    });

    //create reshare
    // const rs1 = await mcbr1.reshare(siri);

    //create quote
    // const q1 = await mcbr1.add_quote(siri, {
    //     post_type: 'microblog',
    //     text_content: 'LMFAOOOO',
    // })

    //print results
    // console.log('reshare 1 => ', await rs1.read())
    console.log('microblog 1 => ', await mcbr1.read())
    // console.log('microblog 2 => ', await mcbr2.read())

}

main();
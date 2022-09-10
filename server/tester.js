const {UserModel} = require('./database')

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

    console.log('Manas follows Veeksha', await manas.follow(veeksha));
    console.log('Veeksha follows Siri', await veeksha.follow(siri))
    console.log('Siri follows Veeksha', await siri.follow(veeksha))
    console.log('Manas follows Siri', await manas.follow(siri));

    console.log(await manas.read())
    console.log(await veeksha.read())
    console.log(await siri.read())
    
    console.log('Siri unfollows Veeksha', await siri.unfollow(veeksha))
    console.log('Siri removes Manas', await siri.remove_follower(manas));
    
    console.log(await manas.read());
    console.log(await veeksha.read())
    console.log(await siri.read())

    console.log('Updating Veeksha Name', await veeksha.update({name: 'Veeksha M Rao'}));
    console.log(await veeksha.read());

}

main();
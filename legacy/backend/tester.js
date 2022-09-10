const { UserModel } = require('./models')

async function main() {
    const manas = await UserModel.create({
        username: 'manashejmadi',
        password: '12345',
        name: 'Manas Hejmadi',
        display_picture_link: 'https://www.google.com',
        coverlink: 'https://www.google.com',
        description: 'Methodical Rogue',
        location: 'Bengaluru',
        biolink: 'https://www.google.com',
    })

    const veeksha = await UserModel.create({
        username: 'veekshahaha',
        password: '12345',
        name: 'Veeksha M',
        display_picture_link: 'https://www.google.com',
        coverlink: 'https://www.google.com',
        description: 'Material Gworl',
        location: 'Bengaluru',
        biolink: 'https://www.google.com',
    })

    // console.log('Manas follows veeksha')
    // await manas.follow(veeksha)
    // console.log('Veeksha follows Manas')
    // await veeksha.follow(manas)
    

    console.log(await manas.json());
    console.log(await veeksha.json())
    // console.log(await veeksha.followers());

    // console.log(await manas.follow(veeksha))
}

main()
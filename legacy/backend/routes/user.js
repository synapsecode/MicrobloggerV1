const router = require('express').Router();
const { UserSchema } = require('../database');
const {UserModel} = require('../models')

router.get('/:name/details', async (req, res) => {
    const name = req.params.name;
    await UserSchema.sync();
    const person = await UserSchema.findOne({where:{username:name}});
    if(person === null){
        res.send('NO-PERSON-FOUND');
        return;
    }
    res.send({
        name: name,
        following: (await person.getFollowers()).map(x => x.name),
        // followers: (await person.getFollowing()).map(x => x.name),
    })
})

//[Create] Person using name & phone number
router.get('/addmanas', async (req, res) => {
    await UserSchema.sync();
    const already_exists = (await UserSchema.findAll()).map((x) => x.username).includes('manashejmadi');
    if (already_exists) {
        res.send('Person with this name already exists');
        return;
    }
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
    res.send('Created Manas');
})

module.exports = router;
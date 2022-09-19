//Imports
const express = require('express');
const bodyParser = require('body-parser');
const { Sequelize } = require('sequelize');
const {sequelize} = require('./database');

//Declarations
const app = express()

//Middleware
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))

//RouteDeclarations

//Routes
app.get('/', async (req, res) => {
    res.send('MicroBloggerAPI v2');
})

//Run Application
if(process.env.FORCESYNC === 'TRUE'){
    (async()=>{
        await sequelize.drop();
        await sequelize.sync({force: true});
        console.log('Force Sync Completed!')
    })();
}else{

app.listen(3000, async () => {
    console.log(`\n\n\\nMicrobloggerAPI listening on port 3000`)
});
}



//Imports
const express = require('express');
const bodyParser = require('body-parser');
const {sequelize} = require('./database');

//Declarations
const app = express()

//Middleware
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended:false}))

//RouteDeclarations

//Routes
app.get('/', async (req, res) => {
  res.send('MicroBloggerAPI v2');
}) 

app.listen(3000, async () => {
  //Enable this after making new relationships or editing tables
  // await sequelize.sync({ force: true });
  console.log(`\n\n\\nMicrobloggerAPI listening on port 3000`)
});

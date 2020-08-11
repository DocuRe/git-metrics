require('dotenv').config();

const fs = require('fs');

if (!fs.existsSync('./public/build/')){
    fs.mkdirSync('./public/build/');
}

fs.writeFileSync('./public/build/config.js', `window.config = ${process.env.GIT_METRICS_CONFIG}`);

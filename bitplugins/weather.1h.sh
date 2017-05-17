#!/usr/local/bin/node

// Weather
// BitBar plugin
// by Dkunin
// Display current weather

const https = require('https');
const fs = require('fs');
const path = require('path');
const localenv = fs.readFileSync(path.join(process.env.HOME, '/.localenv')).toString();
const variables = localenv.split('\n').find(singleItem => singleItem.includes('DARKSKY_API'));
const API_KEY = variables.replace('export ', '').match(/[a-z0-9]/g).join('');

https
    .get(`https://api.darksky.net/forecast/${API_KEY}/55.8929288,37.6537008?exclude=hourly,flags&lang=ru&units=auto`, function(response) {
        var str = '';
        response.on('data', function(chunk) {
            str += chunk;
        });

        response.on('end', function() {
            const result = JSON.parse(str);
            console.log(`${result.currently.temperature} (${result.currently.apparentTemperature}) °C`);
            console.log('---');
            console.log(`${result.currently.summary}`);
            console.log(`Скорость ветра: ${result.currently.windSpeed}`);
        });
    })
    .on('error', function(e) {
        console.log(e);
    });


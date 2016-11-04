#!/usr/bin/env /usr/local/bin/node

// Wakatime
// BitBar plugin
// by Dkunin
// Display number of days, since you were born
//65
var seconds = (new Date() - new Date('01.14.1985')) / 1000;
var minutes = seconds / 60;
var hours = minutes / 60;
var days = Math.ceil(hours / 24);
console.log(days);
console.log('---');
var letterNumber = days - 11569 + 65;
console.log('Seneca Letter | href=http://dkunin.github.io/seneca-letters/html/txt' + letterNumber + '.html');

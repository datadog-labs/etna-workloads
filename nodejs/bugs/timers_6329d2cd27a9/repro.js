const timers = require('timers');
console.log(typeof timers.promises);
console.log(timers.promises === require('timers/promises'));
console.log(Object.keys(timers).includes('promises'));

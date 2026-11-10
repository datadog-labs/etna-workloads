const util = require('util');
const e = new Error('outer', { cause: new Error('inner') });
console.log('shows cause:', util.inspect(e).includes('[cause]: Error: inner'));

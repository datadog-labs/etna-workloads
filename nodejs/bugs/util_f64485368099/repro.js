const util = require('util');
const s = '\u001B]8;;https://example.com/a_(b)?x=1,2*\u0007link\u001B]8;;\u0007';
console.log(JSON.stringify(util.stripVTControlCharacters(s)));

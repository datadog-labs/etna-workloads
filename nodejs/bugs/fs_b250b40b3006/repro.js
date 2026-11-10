const path = require('path');
const p = 'a/*';
console.log(path.posix.matchesGlob('a/b', p));
console.log(path.win32.matchesGlob('a\\b', p));
console.log(path.posix.matchesGlob('a\\b', p));

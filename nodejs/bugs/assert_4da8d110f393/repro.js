const assert = require('assert');
const a = new Error('x', { cause: new Error('a') });
const b = new Error('x', { cause: new Error('b') });
a.stack = b.stack = 'Error: x';
try { assert.deepStrictEqual(a, b); } catch (e) { console.log(e.message.replace(/\n\s+at .*/g, '')); }

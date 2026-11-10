const util = require('util');
const e = new SuppressedError(new Error('boom'), new Error('orig'), 'msg');
const out = util.inspect(e);
console.log(out.includes('boom') && out.includes('orig') ? 'shown' : 'hidden');

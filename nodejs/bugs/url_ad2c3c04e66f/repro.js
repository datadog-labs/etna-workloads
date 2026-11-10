const { urlToHttpOptions } = require('url');
const u = new URL('http://example.com/a?b=1');
u.extra = 'hello';
const o = urlToHttpOptions(u);
console.log(o.extra, o.protocol, o.path);

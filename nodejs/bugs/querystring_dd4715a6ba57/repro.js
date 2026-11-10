const qs = require('querystring');
console.log(JSON.stringify(qs.parse('%C3%A4=café%', null, null)));
console.log(JSON.stringify(qs.parse('%C3%A4=café%', '&&')));

const fs = require('fs');
if (process.platform === 'linux') {
  console.log('O_NOATIME' in fs.constants, typeof fs.constants.O_NOATIME);
  console.log(fs.constants.O_NOATIME === 0o1000000);
} else console.log('true number\ntrue');

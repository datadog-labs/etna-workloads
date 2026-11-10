const fs = require('fs');
for (const k of ['S_IRUSR', 'S_IWUSR']) console.log(k, fs.constants[k]);

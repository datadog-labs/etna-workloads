const fs = require('fs');
try {
  fs.readFileSync(__filename, { encoding: 'bogus' });
} catch (e) {
  console.log(e.code);
  console.log(e.message);
}

'use strict';
const fs = require('fs');
(async () => {
  const fh = await fs.promises.open(__filename);
  fs.closeSync(fh.fd);
  try { await fh.close(); console.log('no error'); }
  catch (e) { console.log(e.code, e.syscall); }
})();

const fs = require('fs').promises;
(async () => {
  const fh = await fs.open(__filename);
  console.log('open fd valid:', fh.fd !== -1);
  await fh.close();
  console.log('fd after close is -1:', fh.fd === -1);
  const other = await fs.open(process.execPath);
  try { await fh.stat(); console.log('stat succeeded'); }
  catch (e) { console.log('stat error:', e.code, e.syscall); }
  await other.close();
})();

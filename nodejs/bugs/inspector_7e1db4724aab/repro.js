'use strict';
const { spawnSync } = require('child_process');
if (process.argv[2] !== 'child') {
  const r = spawnSync(process.execPath, ['--experimental-storage-inspection', __filename, 'child'], { encoding: 'utf8' });
  console.log(r.stdout.trim());
  console.log('exit', r.status);
  process.exit(0);
}
const { Session } = require('node:inspector/promises');
(async () => {
  const s = new Session();
  s.connect();
  await s.post('DOMStorage.enable');
  try {
    const r = await s.post('DOMStorage.getDOMStorageItems', {
      storageId: { isLocalStorage: true, securityOrigin: '', storageKey: '' } });
    console.log('success', JSON.stringify(r));
  } catch (e) { console.log('error', e.code, e.message); }
})();

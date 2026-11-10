if (!process.execArgv.includes('--experimental-vfs')) {
  const r = require('child_process').spawnSync(process.execPath,
    ['--experimental-vfs', '--no-warnings', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const zlib = require('zlib');
const vfs = require('node:vfs');
(async () => {
  const chunks = [];
  for await (const c of zlib.createZipArchive([
    await zlib.ZipEntry.create('dir/b.txt', Buffer.from('nested')),
  ])) chunks.push(c);
  const zip = new zlib.ZipBuffer(Buffer.concat(chunks));
  const v = vfs.create(new vfs.ZipProvider(zip));
  try {
    await v.promises.rename('/dir', '/renamed');
    console.log(await v.promises.readFile('/renamed/b.txt', 'utf8'));
  } catch (e) { console.log('async', e.code); }
  try {
    v.renameSync('/renamed', '/again');
    console.log(v.readFileSync('/again/b.txt', 'utf8'));
  } catch (e) { console.log('sync', e.code); }
})();

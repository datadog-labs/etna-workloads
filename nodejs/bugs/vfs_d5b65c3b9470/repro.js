if (!process.execArgv.includes('--experimental-vfs')) {
  const r = require('child_process').spawnSync(process.execPath, ['--no-warnings', '--experimental-vfs', __filename], { stdio: 'inherit' });
  process.exit(r.status);
}
const zlib = require('zlib');
const vfs = require('node:vfs');
(async () => {
  const chunks = [];
  for await (const c of zlib.createZipArchive([await zlib.ZipEntry.create('a.txt', Buffer.from('hello'))])) chunks.push(c);
  const zip = new zlib.ZipBuffer(Buffer.concat(chunks));
  const v = vfs.create(new vfs.ZipProvider(zip));
  const t = async (n, f) => {
    try { await f(); console.log(n, 'ok'); } catch (e) { console.log(n, e.code); }
  };
  await t('writeFile', () => v.promises.writeFile('/a.txt/child.txt', 'x'));
  await t('mkdir', () => v.promises.mkdir('/a.txt/child'));
  await v.promises.writeFile('/n.txt', 'y');
  await t('rename', () => v.promises.rename('/n.txt', '/a.txt/r.txt'));
  await t('writeFileSync', () => v.writeFileSync('/a.txt/c2.txt', 'x'));
  await t('mkdirSync', () => v.mkdirSync('/a.txt/c3'));
  console.log(zip.has('a.txt/child.txt'), zip.has('a.txt/child/'), zip.has('a.txt/r.txt'));
})();

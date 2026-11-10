const zlib = require('zlib');
async function run(format, comp) {
  const input = Buffer.concat([comp, Buffer.from([1, 2, 3, 4, 5])]);
  const ds = new DecompressionStream(format);
  const w = ds.writable.getWriter();
  w.write(input).catch(() => {});
  w.close().catch(() => {});
  const chunks = [];
  try {
    for await (const c of ds.readable) chunks.push(Buffer.from(c));
    console.log(format, 'ok', Buffer.concat(chunks).toString());
  } catch (e) {
    console.log(format, 'error', e.name);
  }
}
(async () => {
  await run('deflate', zlib.deflateSync('hello'));
  await run('gzip', zlib.gzipSync('hello'));
})();

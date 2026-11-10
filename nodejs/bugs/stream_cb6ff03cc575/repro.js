const { CompressionStream, DecompressionStream } = require('stream/web');
const zlib = require('zlib');
async function run(name, mk, input) {
  try {
    const t = mk();
    const w = t.writable.getWriter();
    const p = (async () => { const out = []; for await (const c of t.readable) out.push(Buffer.from(c)); return Buffer.concat(out); })();
    w.write(input).catch(() => {});
    await w.close().catch(() => {});
    const r = await p;
    console.log(name, 'ok', r.length > 0);
  } catch (e) { console.log(name, 'error', e.name); }
}
(async () => {
  const data = new TextEncoder().encode('hello world');
  await run('compress-ab', () => new CompressionStream('gzip'), data.buffer.slice(0));
  const gz = zlib.gzipSync('hello');
  await run('decompress-ab', () => new DecompressionStream('gzip'), gz.buffer.slice(gz.byteOffset, gz.byteOffset + gz.length));
})();

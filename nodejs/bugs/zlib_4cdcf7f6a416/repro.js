'use strict';
const zlib = require('zlib');
const dictionary = Buffer.from('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
const input = Buffer.from('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '.repeat(100));
function run(s, data) {
  return new Promise((res) => {
    const chunks = [];
    s.on('data', (c) => chunks.push(c));
    s.on('error', (e) => res('error ' + e.code));
    s.on('end', () => res(Buffer.concat(chunks)));
    s.end(data);
  });
}
(async () => {
  const opts = { dictionary, params: { [zlib.constants.ZSTD_c_compressionLevel]: 19, [zlib.constants.ZSTD_c_checksumFlag]: 1 } };
  const expected = await run(zlib.createZstdCompress(opts), input);
  const c = zlib.createZstdCompress(opts);
  c.reset();
  const got = await run(c, input);
  console.log('compress reset same output:', Buffer.isBuffer(got) && got.equals(expected));
  const compressed = zlib.zstdCompressSync(input, { dictionary });
  const d = zlib.createZstdDecompress({ dictionary });
  d.reset();
  const out = await run(d, compressed);
  console.log('decompress reset with dictionary:', Buffer.isBuffer(out) ? out.equals(input) : out);
})();

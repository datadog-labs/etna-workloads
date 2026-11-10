'use strict';
const zlib = require('zlib');
const dictionary = Buffer.from('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');
const input = Buffer.from('Lorem ipsum dolor sit amet, consectetur adipiscing elit. '.repeat(100));
function run(s, data) {
  return new Promise((res) => {
    const c = [];
    s.on('data', (d) => c.push(d));
    s.on('error', (e) => res('error ' + e.code));
    s.on('end', () => res(Buffer.concat(c)));
    s.end(data);
  });
}
(async () => {
  const opts = { dictionary, params: { [zlib.constants.BROTLI_PARAM_QUALITY]: 0 } };
  const exp = await run(zlib.createBrotliCompress(opts), input);
  const r = zlib.createBrotliCompress(opts); r.reset();
  const got = await run(r, input);
  console.log('compress same:', Buffer.isBuffer(got) && exp.equals(got));
  const comp = zlib.brotliCompressSync(input, { dictionary });
  const d = zlib.createBrotliDecompress({ dictionary }); d.reset();
  const out = await run(d, comp);
  console.log('decompress ok:', Buffer.isBuffer(out) ? input.equals(out) : out);
})();

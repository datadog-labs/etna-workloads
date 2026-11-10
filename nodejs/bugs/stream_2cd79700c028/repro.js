const { Readable } = require('stream');

async function run(name, src) {
  const r = Readable.from(src);
  r.on('error', (e) => console.log(name, 'error:', e.code));
  try {
    for await (const c of r) console.log(name, 'chunk:', c);
    console.log(name, 'ended');
  } catch (e) {
    console.log(name, 'caught:', e.code);
  }
}

(async () => {
  await run('sync', [1, null, 2]);
  await run('asyncvals', [Promise.resolve(1), Promise.resolve(null)]);
  await run('asyncgen', (async function* () { yield 1; yield null; })());
  await run('syncgen', (function* () { yield 1; yield null; })());
})();

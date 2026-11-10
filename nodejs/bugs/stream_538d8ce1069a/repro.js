const { Readable, Duplex } = require('stream');
function start(c) { c.enqueue(new Uint8Array(1)); c.close(); }
function run(name, s) {
  const ev = [];
  s.on('data', (d) => ev.push('data' + d.length))
   .on('end', () => ev.push('end'))
   .on('error', (e) => ev.push('error:' + e.code))
   .on('close', () => { console.log(name, ev.join(',')); })
   .resume();
}
run('readable', Readable.fromWeb(new ReadableStream({ start })));
run('duplex', Duplex.fromWeb({
  readable: new ReadableStream({ start }),
  writable: new WritableStream({ write() {} }),
}));

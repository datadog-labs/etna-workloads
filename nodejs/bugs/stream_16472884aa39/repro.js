const { TransformStream } = require('stream/web');
(async () => {
  const s = new TransformStream({ transform(c, ctl) { ctl.enqueue(c); } });
  await new Promise((r) => setTimeout(r, 0));
  const reader = s.readable.getReader();
  const writer = s.writable.getWriter();
  const r = reader.read();
  const c = reader.cancel(new Error('x'));
  const w = writer.write('late');
  const res = await Promise.allSettled([r, c, w]);
  const e = res[2].reason;
  console.log(res.map((x) => x.status).join(','));
  console.log(e && /not a function/.test(e.message) ? 'LEAK' : 'ok');
})();

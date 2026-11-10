const ac = new AbortController();
const reason = new Error('custom reason');
const rs = new ReadableStream({ start(c) {} });
const ws = new WritableStream();
const p = rs.pipeTo(ws, { signal: ac.signal });
ac.abort(reason);
p.then(() => console.log('resolved'), (e) => {
  console.log(e === reason, e.name, e.message);
});

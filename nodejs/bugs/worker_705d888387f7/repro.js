const e = new MessageEvent('message', { data: 5, origin: 'o', lastEventId: 'id' });
console.log(e.type, e.data, e.origin, e.lastEventId);
try { new MessageEvent(); console.log('no throw'); } catch (err) { console.log(err.name); }
const { port1, port2 } = new MessageChannel();
port1.onmessage = (ev) => {
  console.log(ev.constructor.name, ev.type, ev.data, ev.origin, ev.lastEventId, Array.isArray(ev.ports));
  port1.close();
};
port2.postMessage('hi');

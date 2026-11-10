const net = require('net');
for (const o of [{ objectMode: true }, { readableObjectMode: true }, { writableObjectMode: true }]) {
  try {
    new net.Socket(o);
    console.log(Object.keys(o)[0], 'no throw');
  } catch (e) {
    console.log(Object.keys(o)[0], e.code, e.message);
  }
}

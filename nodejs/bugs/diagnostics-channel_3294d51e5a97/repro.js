const dc = require('diagnostics_channel');
const ch = dc.tracingChannel('repro');
ch.subscribe({ start() {}, end() {}, asyncStart() {}, asyncEnd() {}, error() {} });
try {
  ch.traceCallback((cb) => cb(null, 'result'), 0, undefined, null, (err, res) => {
    console.log('callback ok', err, res);
  });
} catch (e) {
  console.log('threw', e.name);
}

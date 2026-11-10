const inspector = require('inspector');
try {
  inspector.open(65536 + 9229, '127.0.0.1');
  console.log('opened');
  inspector.close();
} catch (e) {
  console.log('error', e.code);
}

'use strict';
const net = require('net');
try { const s = new net.Socket(); s._parent = undefined; s._unrefTimer(); console.log('unref ok'); }
catch (e) { console.log('unref threw', e.constructor.name); }
const s = new net.Socket();
s._parent = undefined;
s.on('error', (e) => console.log('destroy error', e.constructor.name));
s.on('close', () => console.log('destroy closed'));
s.destroy();

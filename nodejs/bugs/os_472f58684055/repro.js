'use strict';
const s = require('os').constants.signals;
console.log('frozen:', Object.isFrozen(s));
try { s.SIGFOO = 1; } catch (e) { console.log('add threw', e.constructor.name); }
try { delete s.SIGINT; } catch (e) { console.log('delete threw', e.constructor.name); }
console.log('SIGFOO' in s, 'SIGINT' in s);

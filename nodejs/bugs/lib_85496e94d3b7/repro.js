const { Writable } = require('stream');
const { Console } = require('console');
const stream = new Writable({ write() { throw null; } });
const c = new Console({ stdout: stream });
try { c.log('test'); console.log('no throw'); } catch (e) { console.log('threw', e instanceof TypeError ? 'TypeError' : e); }

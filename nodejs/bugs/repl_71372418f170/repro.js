'use strict';
const readline = require('readline');
const { EventEmitter } = require('events');
class FakeInput extends EventEmitter {
  resume() {} pause() {} write() {} end() {}
}
FakeInput.prototype.readable = true;
const fi = new FakeInput();
const rli = new readline.Interface({ input: fi, output: fi, terminal: true, removeHistoryDuplicates: true });
function submit(line) { rli.line = line; fi.emit('keypress', '', { name: 'enter' }); }
submit('line1\nline2');
submit('other');
submit('line1\nline2');
console.log(JSON.stringify(rli.history));
rli.close();

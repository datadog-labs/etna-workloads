const { pipeline, Readable } = require('stream');
pipeline(Readable.from(['hello\n']), process.stdout, (err) => {
  process.stderr.write('pipeline done: ' + (err ? err.code : 'ok') + '\n');
});
process.on('exit', () => process.stderr.write('exit\n'));

const { Readable } = require('stream');
const { ReadableStream } = require('stream/web');
for (const v of [1, {}, null, undefined, 'x']) {
  try {
    if (v === 'x') { ReadableStream.from(v); console.log('string ok'); continue; }
    ReadableStream.from(v);
    console.log('no throw');
  } catch (e) {
    console.log(e.name, e.code, e.message);
  }
}

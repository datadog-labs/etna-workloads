const names = ['ReadableStream','ReadableStreamDefaultReader','ReadableStreamBYOBReader','ReadableStreamBYOBRequest','ReadableStreamDefaultController','ReadableByteStreamController','WritableStream','WritableStreamDefaultWriter','WritableStreamDefaultController','TransformStream','TransformStreamDefaultController','ByteLengthQueuingStrategy','CountQueuingStrategy'];
for (const n of names) {
  const d = Object.getOwnPropertyDescriptor(globalThis[n].prototype, Symbol.toStringTag);
  console.log(n, d && JSON.stringify({v: d.value, w: d.writable, e: d.enumerable, c: d.configurable, g: typeof d.get}));
}
console.log(Object.prototype.toString.call(new ReadableStream()));
console.log(Object.prototype.toString.call(new CountQueuingStrategy({highWaterMark:1})));

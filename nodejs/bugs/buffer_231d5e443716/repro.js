const ab = new ArrayBuffer(4, { maxByteLength: 16 });
const b = Buffer.from(ab);
ab.resize(8);
console.log(b.length);

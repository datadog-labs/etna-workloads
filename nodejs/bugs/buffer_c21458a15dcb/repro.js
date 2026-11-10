const a = Buffer.alloc(0);
const b = Buffer.allocUnsafeSlow(Buffer.poolSize);
const c = Buffer.alloc(10);
console.log(a.parent instanceof ArrayBuffer, a.parent === a.buffer);
console.log(b.parent instanceof ArrayBuffer, b.parent === b.buffer);
console.log(c.parent instanceof ArrayBuffer);

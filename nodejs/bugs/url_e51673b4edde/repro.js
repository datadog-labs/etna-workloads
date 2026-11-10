const p = new URLPattern({ pathname: '/a' });
console.log(Object.prototype.toString.call(p));
console.log(Object.prototype.toString.call(URLPattern.prototype));
console.log(JSON.stringify(Object.getOwnPropertyDescriptor(URLPattern.prototype, Symbol.toStringTag)));

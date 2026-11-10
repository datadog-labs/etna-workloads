class MyErr extends DOMException {
  hello() { return 'hi'; }
}
const e = new MyErr('msg', 'AbortError');
console.log(e instanceof MyErr);
console.log(Object.getPrototypeOf(e) === MyErr.prototype);
console.log(typeof e.hello);
console.log(e.name, e.code, e.message);

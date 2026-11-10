const x = {};

Object.defineProperty(x, "foo", {
  /** @param {number} v */
  set(v) {},
});

x.foo = 1;

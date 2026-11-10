function test4(options?: { a?: boolean; b?: boolean }) {
  if (options?.a === false || options.b) {
    options;
  }
}

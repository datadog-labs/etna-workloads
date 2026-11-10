function test1(arg: [[undefined, Error] | [number, undefined]]) {
  const [[p1, p1Error]] = arg;
  if (p1Error) {
    return;
  }
  const n: number = p1;
}

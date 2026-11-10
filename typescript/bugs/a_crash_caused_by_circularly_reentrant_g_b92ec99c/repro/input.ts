function test2(a: number | string) {
  if (typeof a === "number") {
    const fn: { (arg: typeof a): boolean; } = () => true;
    return fn;
  }
  return;
}

test2(0)?.(100);
test2(0)?.("");

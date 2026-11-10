declare const foo: ["a", string, number] | ["b", string, boolean];

export function test(arg: { index?: number }) {
  const { index = 0 } = arg;
  if (foo[index] === "a") {
    const x: never = foo;
  }
}

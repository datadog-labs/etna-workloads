let x: { [x: string]: { a: 0 } } & { [x: string]: { b: 0 } };
x = { y: { a: 0, b: 0, c: 0 } };

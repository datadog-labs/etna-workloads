declare const test1:
  | ((...args: [a: string | number, b: number | boolean]) => void)
  | ((...args: [c: number | boolean, d: string | boolean]) => void);

test1(42, true);
test1(42, [true]); // error

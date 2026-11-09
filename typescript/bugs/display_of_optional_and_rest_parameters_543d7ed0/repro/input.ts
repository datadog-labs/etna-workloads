declare const rest:
  | ((v: { a: true }, ...rest: string[]) => unknown)
  | ((v: { b: true }) => unknown);
rest({ a: true, b: true }, "foo", "bar");
export const x = rest;

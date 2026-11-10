declare function test1<T extends { x: string }>(
  a: T,
  b: NoInfer<T> | (() => NoInfer<T>),
): void;

test1({ x: "foo" }, { x: "bar" });
test1({ x: "foo" }, { x: "bar", y: 42 });

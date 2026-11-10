declare function test1<const T>(obj: {
  [K in keyof T]: T[K];
}): [T, typeof obj];

const result1 = test1({
  prop: "foo",
  nested: { nestedProp: "bar" },
});
const n: number = result1;

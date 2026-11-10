type PropertyKey = string | number | symbol;
type Exclude<T, U> = T extends U ? never : T;
const obj = {
  get id() { return 1; },
  name: "test",
};
type Omit2<T, D extends PropertyKey> = { [K in keyof T as Exclude<K, D>]: T[K] };
declare function omit2<O, Mask extends { [K in keyof O]?: true }>(obj: O, mask: Mask): Omit2<O, keyof Mask>;
const obj2 = omit2(obj, { name: true });
obj2.id;

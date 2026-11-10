declare function foo<T>(t: T): typeof foo<T>;
const x = foo("");

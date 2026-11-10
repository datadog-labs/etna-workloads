type U = "abc" | Uppercase<string> | "ABC";
declare let u: U;
const x: "abc" = u;
type V = "abc" | Lowercase<string> | "x";
declare let v: V;
const y: number = v;

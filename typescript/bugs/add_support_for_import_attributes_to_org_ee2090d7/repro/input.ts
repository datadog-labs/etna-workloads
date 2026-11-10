import { a } from "./mod" with { type: "json" };
import { b } from "./mod";
import { c } from "./mod" with { type: "json" };
console.log(a, b, c);

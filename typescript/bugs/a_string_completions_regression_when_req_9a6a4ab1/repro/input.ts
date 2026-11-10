enum myEnum { valA = "valA", valB = "valB" }
interface M { ["valA"]: "1" | "2"; ["valB"]: "3" | "4"; }
declare function f<K extends keyof typeof myEnum>(a: K, b: M[K]): void;
f("valA", "");

function Foo() {}
Foo[`b`] = function () {};
type Test = keyof typeof Foo;
const t: Test = "b";
const bad: Test = "zzz";

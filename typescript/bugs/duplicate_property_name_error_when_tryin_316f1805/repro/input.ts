export {};
const prop = "abc";
function foo(): void {};
foo.abc = 10;
foo[prop] = 10;
interface T0 {
    [prop]: number;
    abc: number;
}

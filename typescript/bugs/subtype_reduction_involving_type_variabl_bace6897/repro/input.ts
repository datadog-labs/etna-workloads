type A = { a: string };
type B = { b: string };
export function f1<T extends A | B>(t: T, x: A | B) {
    return [t, x];
}

interface I {
    /** doc of a */
    a: number;
    /** doc of b */
    b: number;
}
declare const o: I;
const { a: b } = o;
b;

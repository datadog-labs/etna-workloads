declare const f: ((x: unknown) => x is string) | ((x: unknown) => boolean);
declare const v: string | number;
if (f(v)) {
    const a: string = v;
} else {
    const b: number = v;
}

declare const foo: {
    /** @deprecated */
    (a: string, b: string): string;
    (a: string, b: number): string;
};
foo(1, 1);

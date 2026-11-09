export const f = <T extends string>(x: T) => `a
b${x}c
d` as const;

declare function f<T extends unknown[]>(...args: T): T;
declare const s: Set<number>;
export const r = f(...s);
const x: string = r;

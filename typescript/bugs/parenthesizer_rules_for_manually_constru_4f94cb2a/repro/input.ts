declare let a: any, b: any, c: any;
export const x = a! || b ?? c;
export const y = a ?? b! && c;
export const z = a && b! ?? c;
export const w = c ?? a! || b;

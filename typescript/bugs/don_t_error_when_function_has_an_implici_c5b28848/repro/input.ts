function f(x: boolean): unknown { if (x) return 1; }
function g<T extends undefined>(x: boolean): T { if (x) return undefined as T; }

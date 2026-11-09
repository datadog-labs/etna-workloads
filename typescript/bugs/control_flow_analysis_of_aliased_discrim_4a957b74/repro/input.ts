type D = { kind: 'a'; a: number } | { kind: 'b'; b: string };
function f(obj: D) {
    const k = (obj.kind);
    if (k === 'a') {
        return obj.a;
    }
    return obj.b;
}
function g(obj: D) {
    const { kind: k } = (obj);
    const j = (obj);
    if (k === 'a') { return obj.a; }
    return obj.b;
}

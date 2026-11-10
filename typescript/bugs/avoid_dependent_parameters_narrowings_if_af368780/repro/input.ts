declare function f(cb: (...args: ["a", number] | ["b", string]) => void): void;
f((kind, payload) => {
    payload = payload;
    if (kind === "a") {
        const n: number = payload;
    }
});
f((kind, payload) => {
    kind = kind;
    if (kind === "a") {
        const n: number = payload;
    }
});

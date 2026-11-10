function f(x: string | number | boolean) {
    switch (true) {
        case typeof x === "string":
        case typeof x === "number":
            const a: string | number = x;
            break;
        default:
            const b: boolean = x;
    }
}

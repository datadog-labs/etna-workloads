function f() {
    const iter = (function* () {
        iter;
        yield 1;
    })();
}

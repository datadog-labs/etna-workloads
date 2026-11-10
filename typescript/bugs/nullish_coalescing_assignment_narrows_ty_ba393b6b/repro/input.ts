function f1(a?: boolean): void {
    a ??= true;
    if (a === false) {
        console.log(a);
    }
}

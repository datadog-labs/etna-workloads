interface Foo {
    a: ((e: any) => void) | null;
}

const foo: Foo = {
    a: fn
}

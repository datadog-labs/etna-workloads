function fn(Foo: number) {
     type Foo = typeof Foo;
    return 0 as any as {x: Foo};
}

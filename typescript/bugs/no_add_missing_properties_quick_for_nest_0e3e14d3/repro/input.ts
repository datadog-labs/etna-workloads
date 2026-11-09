interface Foo {
    a: number;
    b: string;
}

interface Bar {
    value: Foo;
}

const bar: Bar = {
    value: {
        a: 10
    }
}

import { Bar, Baz } from "./a";

const Foo = {
    bar: Bar,
    baz: Baz,
};

export function fn(name: keyof typeof Foo) {
    return Foo[name];
}

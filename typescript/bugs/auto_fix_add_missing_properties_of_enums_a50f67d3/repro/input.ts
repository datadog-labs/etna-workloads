namespace Foo.Bar {
    export enum E { E1 = 0, E2 = 1 }
    export interface Baz { prop3: E.E1; }
}
const foo: Foo.Bar.Baz = {};

import * as foo from './foo'
export as namespace foo
export = foo;

declare global {
    const foo: typeof foo;
}

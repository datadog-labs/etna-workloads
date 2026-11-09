/** @import { Foo } from './types.d.ts' */

export function f2() {
    /** @type {Set<Foo>} */
    const foo = new Set(['a']);
    return foo;
}

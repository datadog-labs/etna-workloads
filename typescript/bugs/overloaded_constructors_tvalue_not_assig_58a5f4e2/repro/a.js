/**
 * @template T
 */
export class Foo {
    /**
     * @constructor
     * @overload
     */
    constructor() { }

    /**
     * @param {T} value
     */
    bar(value) { }
}

/** @type {Foo<number>} */
let foo;
foo = new Foo();

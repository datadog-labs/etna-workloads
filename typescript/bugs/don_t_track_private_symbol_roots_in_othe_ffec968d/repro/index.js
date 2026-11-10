import Test from './test/Test.js'

/**
 * @typedef {Object} Options
 * @property {typeof import("./Test.js").default} [test]
 */

class X extends Test {
    /**
     * @param {Options} options
     */
    constructor(options) {
        super();
        if (options.test) {
            this.test = new options.test();
        }
    }
}

export default X;

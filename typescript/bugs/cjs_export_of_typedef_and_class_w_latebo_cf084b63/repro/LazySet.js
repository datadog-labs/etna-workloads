/**
 * @typedef {Object} SomeObject
 */
class LazySet {
    /** @param {LazySet} iterable */
    addAll(iterable) {}
    [Symbol.iterator]() {}
}
module.exports = LazySet;

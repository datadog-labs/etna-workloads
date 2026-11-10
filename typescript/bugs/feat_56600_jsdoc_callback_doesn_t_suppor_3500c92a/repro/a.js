/**
 * @callback C
 * @this {{ a: string, b: number }}
 * @param {string} a
 * @param {number} b
 * @returns {boolean}
 */

/** @type {C} */
const cb = function (a, b) {
    this
    return true
}

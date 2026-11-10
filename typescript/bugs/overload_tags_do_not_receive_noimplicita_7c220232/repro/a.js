/**
 * @overload
 * @param {number} x
 */

/**
 * @overload
 * @param {string} x
 */

/**
 * @param {string | number} x
 * @returns {string | number}
 */
function id(x) {
    return x;
}

export let a = id(123);

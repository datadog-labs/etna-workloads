/** @this {{ n: number }}
 * @param {string} s
 * @return {number}
 */
function f(s) {
    return this.n + s.length
}
const o = { f, n: 1 }
o.f('hi')
const bad = { f, n: 'x' }
bad.f('hi')

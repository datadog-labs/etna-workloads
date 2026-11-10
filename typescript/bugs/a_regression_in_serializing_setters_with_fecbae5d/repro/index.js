export class I {}
Object.defineProperty(I.prototype, "x", {
    /**
     * @param {number} v
     */
    set: (v) => {}
});
export class J {}
Object.defineProperty(J.prototype, "y", {
    set: 42
});

/** @typedef {Object} Dummy */
/**
 * @template T
 * @param {{m(): void} & ThisType<{x: number}>} o
 */
function infer(o) {}
infer({
    m() {
        this.x = 2;
        this.x;
    },
});

class C {
    /**
     * @this {{fn(a: string): void}}
     * @param {string} a
     */
    p = (a) => this.fn("" + a);
}

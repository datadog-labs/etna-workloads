export const kBar = Symbol("bar");

export class foo0 {
    /**
     * @protected
     * @type {null | string}
     */
    [kBar] = null;

    get bar() {
        return this[kBar];
    }
    /**
     * @type {string}
     */
    set bar(value) {
        this[kBar] = value;
    }
}

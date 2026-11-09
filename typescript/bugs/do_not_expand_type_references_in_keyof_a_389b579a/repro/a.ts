type O = {
    prop: string
    prop2: string
}
export const fn = (v: O['prop'], key: keyof O) => {};

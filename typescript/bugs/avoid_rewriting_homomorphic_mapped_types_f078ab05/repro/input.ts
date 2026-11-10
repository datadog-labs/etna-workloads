export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type PartialProperties<T, K extends keyof T> = Partial<Pick<T, K>> & Omit<T, K>;
export function doSomething_Actual<T extends { prop: string }>(a: T) {
    const x: { [P in keyof PartialProperties<T, "prop">]: PartialProperties<T, "prop">[P]; } = null as any;
    return x;
}

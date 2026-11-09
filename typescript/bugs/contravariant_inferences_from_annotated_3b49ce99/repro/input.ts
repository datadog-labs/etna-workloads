declare function filter<T>(predicate: (value: T, index: number) => boolean): T;
const a = filter((pose?: number) => true);
const n: number = a;

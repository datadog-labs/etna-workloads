declare function fx1<T extends [string, string, string, 'a' | 'b']>(x: T): T;
const t3 = ['x', 'y', 'z'] as const;
fx1([...t3, 'a']);

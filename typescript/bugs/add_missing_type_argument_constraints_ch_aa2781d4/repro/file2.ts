type Bar<T> = import('./file1').Foo<T>;
export type B = Bar<number>;

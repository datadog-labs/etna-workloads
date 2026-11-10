declare function match<T>(cb: (value: T) => boolean): T;
declare function foo(pos: { x?: number; y?: number }): boolean;
foo({ y: match(y => y > 0) });
declare function foo2(point: [number?]): boolean;
foo2([match(y => y > 0)]);

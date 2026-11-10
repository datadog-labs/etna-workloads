interface HasInstanceOf { [Symbol.hasInstance](x: unknown): boolean }
declare const rhs: HasInstanceOf & object;
declare const lhs: any;
lhs instanceof rhs;

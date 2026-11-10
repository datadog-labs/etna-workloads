type Foo<V> = {
    [K in keyof V]: Foo<V[K]>;
}
type Bar<V> = {
    [K in keyof V]: V[K] extends object ? Bar<V[K]> : string;
}
function test<V>(value: Foo<V>): V {
  return undefined as any;
}
declare const bar: Bar<any>;
const r = test(bar);
const x: number = r;

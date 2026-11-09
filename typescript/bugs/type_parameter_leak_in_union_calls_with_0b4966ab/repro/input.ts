interface Err<T> {
  f<U>(a: (err: T) => U): Err<U>;
}
interface Ok<T> {
  f(a: (err: T) => unknown): Err<T>;
}
declare const e: Err<0> | Err<1> | Ok<2>;
export const e2 = e.f((e) => e);

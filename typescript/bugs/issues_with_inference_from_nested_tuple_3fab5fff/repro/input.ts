type T1<T> = [number, T1<{ x: T }>];
type T2<T> = [42, T2<{ x: T }>];

function qq<U>(x: T1<U>, y: T2<U>) {
    x = y;
    y = x;
}

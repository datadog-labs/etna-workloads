interface Foo { foo: string }
interface Promise<T> { then(cb: (v: T) => void): void }
async function f(x: (a: number) => Promise<Foo>) {
    await x(1).
    ;
}

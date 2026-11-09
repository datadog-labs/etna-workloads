type S<T_Sync, T_Async> = Iterable<T_Sync> & AsyncIterable<T_Async>;
class A {}
class B { b = 1 }
async function loop(stream: S<A, B>) {
  for (const a of stream) {}
  for await (const b of stream) {
    const n: number = b;
  }
}

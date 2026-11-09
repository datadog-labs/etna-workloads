async function fn2<T extends Promise<void> | void>(a: T) {
  await a;
}

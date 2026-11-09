interface Promise<T> { then<U>(cb: (v: T) => U): Promise<U>; }
type MyType = {
  foo: string;
};
declare function fakeTest(cb: () => MyType | Promise<MyType>): void;
fakeTest(() => {
  return {
    
  };
});

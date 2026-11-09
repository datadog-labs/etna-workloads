declare const foobar: { type: "foo"; foo: number } | { type: "bar"; bar: string };
const foobarPred = (fb: typeof foobar) => fb.type === "foo";
if (foobarPred(foobar)) {
  foobar.foo;
}

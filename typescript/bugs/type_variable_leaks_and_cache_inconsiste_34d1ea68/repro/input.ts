const createTransform = <I, O>(tr: (from: I) => O) => tr;

function withP3<P>(p: P) {
  const m =
    <I,>(from: I) =>
    <I2,>(from2: I2) => ({ ...from, ...from2, ...p });
  return createTransform(m);
}

export const addP3 = withP3({ a: 1 });
export const addP3_other = withP3({ foo: 'bar' });

const createTransform = <I, O>(tr: (from: I) => O) => tr;

function withP2<P>(p: P) {
  const m = <I,>(from: I) => ({ ...from, ...p });
  return createTransform(m);
}

export const addP2 = withP2({ foo: 1 });
export const added2 = addP2({ bar: 2 });

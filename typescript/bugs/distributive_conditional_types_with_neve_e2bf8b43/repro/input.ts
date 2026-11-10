type IsNumber<T> = T extends number ? true : false;
type Conflicted = { x: true } & { x: false };
export const v: IsNumber<Conflicted> = true;

type A = { disabled?: boolean | undefined };
type B = { disabled?: boolean };
declare const ab: A & B;
ab.disabled = undefined;

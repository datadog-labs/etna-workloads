export enum Enum {
  A = "a",
  B = "b"
}

export type Type = { x?: { [Enum.A]: 0 } };

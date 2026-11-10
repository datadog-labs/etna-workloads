type X =
  | { name: string; [key: string]: any }
  | { name: "john"; someProp: boolean };

const obj = { name: "john", someProp: "foo" } satisfies X;

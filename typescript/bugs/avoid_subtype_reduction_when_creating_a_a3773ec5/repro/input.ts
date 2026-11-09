type narrow<def> = def extends string
  ? def
  : def extends [unknown, ...unknown[]]
  ? def
  : {
      [k in keyof def]: narrow<def[k]>;
    };

declare const parse: <def>(def: narrow<def>) => def;

export const result = parse([{ a: "foo" }]);

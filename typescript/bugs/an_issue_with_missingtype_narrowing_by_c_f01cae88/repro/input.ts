interface A { optionalProp?: "hello"; }
export function func(arg: A) {
  const { optionalProp } = arg;
  switch (optionalProp) {
    case undefined: return undefined;
    case "hello": return "hello";
    default: assertUnreachable(optionalProp);
  }
}
declare function assertUnreachable(_: never): never;

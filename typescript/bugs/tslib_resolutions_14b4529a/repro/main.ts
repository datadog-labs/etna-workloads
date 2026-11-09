export function foo(args: any) {
  const { bar, ...extraArgs } = args;
  return extraArgs;
}

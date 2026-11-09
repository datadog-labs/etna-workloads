declare function tag(s: TemplateStringsArray): number;
const a = tag`x` ?? "unreachable";
const b = (1 as number) ?? 2;

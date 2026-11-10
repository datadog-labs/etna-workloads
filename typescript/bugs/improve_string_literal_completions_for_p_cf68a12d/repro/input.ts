declare function bar1<P extends "" | "bar" | "baz">(p: { type: P }): void;

bar1({ type: "" })

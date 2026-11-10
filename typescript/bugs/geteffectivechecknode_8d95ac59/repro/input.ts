const f = (): { a: true } => (({}) satisfies unknown) satisfies unknown;
f();

interface I {
	foo: string;
}

function f() {
    const foo = { foo: '' } satisfies I;
}

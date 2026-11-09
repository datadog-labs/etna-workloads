type Thing = { id: string; label: string };
declare function find(id: string): undefined | Thing;
declare function fun(thing: Thing): void;
fun({
    id: 'foo',
    ...find('foo') ?? { label: 'Foo' },
});

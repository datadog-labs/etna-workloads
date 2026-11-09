declare function get_things(_: number | undefined): Promise<number[]>;

async function foobar() {
    let before: number | undefined = undefined;
    for (let i = 0; i < 2; i++) {
        const results = await get_things(before);
        before = results[0];
    }
}

declare const xs: AsyncIterable<number>;
for await (const x of xs) {
    console.log(x);
}
export {};

interface IThing<T> { owner: T; }
const qwe = {
    four: {} as IThing<typeof qwe>,
}

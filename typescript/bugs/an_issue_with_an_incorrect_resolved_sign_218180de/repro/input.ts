m({ foo: $("foo") });
m({ foo: $("foo") });
declare const m: <S extends string>(s: { [_ in S]: { $: NoInfer<S> } }) => void
declare const $: <S, T extends S>(s: T) => { $: S }
type NoInfer<T> = [T][T extends any ? 0 : never];

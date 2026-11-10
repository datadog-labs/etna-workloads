Input: a generic JSX component `T<Entry>` whose props are an intersection with a conditional type, used with a context-sensitive
arrow attribute (`getTranslationEntry`) plus an extra attribute `args="a"` that is only valid once `Entry` is inferred.
Clean: no errors. Injected: spurious TS2322 "Property 'args' does not exist on type 'IntrinsicAttributes & {...}'"
(excess-property check is applied to the fresh attributes type during the SkipContextSensitive pass).

input.ts passes `1 satisfies number` as a call argument and as an array-literal element where a string is expected.
Clean build reports the errors at the inner expression (`1`); the injected build reports them at the whole
`satisfies` expression (different column/span), because getEffectiveCheckNode is no longer used.

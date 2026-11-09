type WrappedStringOr<T> = { value?: string } | { value?: T };
function booleanBad(wrapped: WrappedStringOr<boolean> | null) {
    if (typeof wrapped?.value !== 'string') {
        return null;
    }
    return wrapped.value;
}

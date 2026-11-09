type Union =
    | { type: 'a'; variant: 1 }
    | { type: 'a'; variant: 2 }
    | { type: 'b' };

export function example2(value: Union): { type: 'a'; variant: 2 } | null {
    if (value.type !== 'a') {
        return null;
    }
    if (value.type === 'a' && value.variant === 1) {
        return null;
    }
    return value;
}

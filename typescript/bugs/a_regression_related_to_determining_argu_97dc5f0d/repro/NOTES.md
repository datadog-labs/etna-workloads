Input: `fn(...a, )` where `a` is a 2-tuple `as const` and `fn` takes 3 params; the script asks the language service for signature help at the trailing comma.
Clean build reports argumentCount 3; the injected build reports 4 (spread elements and trailing comma are miscounted).

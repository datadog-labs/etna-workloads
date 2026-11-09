Calls a function of type `(...args: never) => void` with no arguments under --strict.
Clean build reports an error (TS2554/arg mismatch) and exits 2; the injected build treats the never rest as an empty rest and accepts the call silently (exit 0).

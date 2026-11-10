Input destructures and iterates (`for..of`) a value of type `number[] | ({t:"a"} & {t:"b"})`, where the intersection reduces to `never`.
Clean: no errors (the never member is dropped from the union). Injected: iterability errors are reported, because the type is no longer reduced in getIterationTypesOfIterable.

Input: generic generator callbacks passed to `outer`/`outer2`/`outer3` that `yield* inner(value)`, where `inner` is a generic call returning an iterable.
Run with tsc --strict --noEmit and print diagnostics.
Clean and injected builds report different diagnostics: the injected build lets `silentNeverType` leak into the inferred generator types, so the expected errors (e.g. for `outer3` and `inner2`) are missing or different.

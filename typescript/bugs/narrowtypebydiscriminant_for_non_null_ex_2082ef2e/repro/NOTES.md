Input: a discriminated union behind an optional property, narrowed via `t.thing!.name !== "B"` (non-null assertion access).
Clean: no errors; `t.thing!.message` / `t.thing!.id` are narrowed correctly.
Injected: the non-null access is not treated like an optional chain in narrowByDiscriminant, so TS2339 errors are reported for `message` and `id`.

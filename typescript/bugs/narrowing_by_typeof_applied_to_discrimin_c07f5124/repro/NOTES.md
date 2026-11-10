input.ts narrows `wrapped` via `typeof wrapped?.value !== 'string'` where `wrapped` is a union containing null and a discriminant-like optional property.
Clean: no errors. Injected: reports TS18047 "'wrapped' is possibly 'null'" at `wrapped.value`, because the optional-chain non-null narrowing is skipped when the discriminant path is taken.

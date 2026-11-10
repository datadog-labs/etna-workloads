Under exactOptionalPropertyTypes, `{a?: string}` and `{a?: string | undefined}` are not identical.
The input assigns a generic conditional-type function using one to the other (identity check via compareProperties).
Clean: reports error TS2322. Injected: no error, since missing is compared as undefined.

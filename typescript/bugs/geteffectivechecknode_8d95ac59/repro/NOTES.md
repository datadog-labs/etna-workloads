Input: an arrow function with return type `{ a: true }` whose body is `(({}) satisfies unknown) satisfies unknown`.
The TS2741 error should be reported at the inner `{}` (clean: column 40-ish, on the `{}`); the injected build only skips one
level of parentheses/satisfies in getEffectiveCheckNode, so it reports the error at the wrong, wider node (`({}) satisfies unknown`)
with a different column.

Input destructures with a rename: `const { a: b } = o;` where interface I has documented properties `a` and `b`.
Quick info on the usage `b` (language service) shows its documentation.
Clean: "doc of a" (looks up the property name `a`). Injected: "doc of b" (looks up the local name `b`, taking the other field's docs).

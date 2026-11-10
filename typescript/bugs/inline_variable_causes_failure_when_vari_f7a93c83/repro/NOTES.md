Input: `const { foo } = props;` (destructured declaration) with the selection on `props` in the initializer.
The script asks the language service for applicable refactors at that selection.
Clean: "Inline variable" is not offered. Injected: it is offered (the isIdentifier(parent.name) check was removed), so inlining a destructured declaration is wrongly allowed.

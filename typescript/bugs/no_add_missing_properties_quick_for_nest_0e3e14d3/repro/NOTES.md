Input: a nested object literal `{ value: { a: 10 } }` assigned to `Bar` whose `value: Foo` lacks required `b`.
run.cjs asks the language service for code fixes at the semantic error on `value`.
Clean: offers "Add missing properties" (inserting `b: ""`). Injected: the contextual type is not used, so no such fix is offered.

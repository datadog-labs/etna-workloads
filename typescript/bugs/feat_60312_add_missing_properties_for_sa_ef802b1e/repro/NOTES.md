Input: `const b = {} satisfies Foo;` where Foo requires properties a and b; the script asks the language service for code fixes at the TS1360 diagnostic.
Clean: offers "Add missing properties" and inserts `a: 0, b: ""` into the object literal.
Injected: the fix-add-missing-member code fix doesn't handle the satisfies diagnostic, so no such fix is offered.

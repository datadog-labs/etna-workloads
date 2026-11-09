Input declares `const { value = "123" } = thing;` (binding element with initializer) and uses it as an enum member initializer.
Clean: the evaluator ignores the binding element, so tsc reports an error (enum initializer must be constant) and emits a computed member.
Injected: the binding initializer is treated as a constant "123", so no error and the enum member is inlined as a string constant.

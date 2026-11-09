Input: `type Foo<T extends { x: string = a }> = T` (grammar error: initializer in a type literal member). A language-service "Extract type" refactor is applied to the `{ ... }` range.
Clean: the formatter skips the grammar-error child, giving a properly formatted extracted alias.
Injected: the grammar-error child is consumed by the formatter, so the generated text edits differ in formatting/indentation (or crash).

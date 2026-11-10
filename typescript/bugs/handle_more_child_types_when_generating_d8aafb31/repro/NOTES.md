Input: `export default (class { foo() {} });` — a parenthesized class expression in an export assignment.
repro.sh prints the language-service navigation bar tree for it.
Clean: skips the parentheses, so the class's member `foo` appears as a child of the default export.
Injected: the parenthesized class is not recognized, so the `foo` child is missing from the tree.

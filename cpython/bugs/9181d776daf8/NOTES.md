Reproducer for gh-142966: `POINTER("node").set_type(node)` should set the pointer
type's buffer format to "&" + element format. It prints the memoryview format of a
pointer instance. Clean prints the "&T{...}" format; buggy prints a different
(unset/generic) format.

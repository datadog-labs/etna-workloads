create_autospec on a function whose annotation references an undefined name (lazily evaluated in 3.14+).
Clean: mock uses inspect.signature(..., annotation_format=FORWARDREF), prints "ok".
Buggy: plain inspect.signature evaluates annotations, raising NameError.

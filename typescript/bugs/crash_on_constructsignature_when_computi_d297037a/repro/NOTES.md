Input declares a variable whose inferred type is `{ prototype: DivElement; new(): DivElement } | undefined` (type with a construct signature).
The script asks the language service for interactive inlay hints (variable type hints) for it.
Clean: prints the hint text. Injected: the ConstructSignature case is missing, so the call hits a Debug failure and the script prints "crash: ...".

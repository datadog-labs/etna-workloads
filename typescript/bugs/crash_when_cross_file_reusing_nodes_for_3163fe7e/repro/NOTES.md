Language-service script: three in-memory files; a class extends one whose member is `["constructor"]!: KlassConstructor<typeof ElementNode>` (type from another file).
Requests class-member-snippet completions inside the subclass body and prints the snippet entries.
Clean: the `["constructor"]` snippet is produced with insertText `["constructor"]: KlassConstructor<typeof ElementNode>;`.
Injected: literal printing uses the wrong source file for cross-file reused nodes, so the output differs (crash/wrong text).

Input: Node16 project with rootDirs ["/src"], /src/index.ts importing "./person.js"; the language service's getEditsForFileRename renames person.ts to vip.ts.
Clean build keeps the extension in the rewritten specifier ("./vip.js").
Injected build strips it for non-Node10 resolution ("./vip"), so the printed edit differs.

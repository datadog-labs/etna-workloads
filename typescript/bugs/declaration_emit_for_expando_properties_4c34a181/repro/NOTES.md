Input: an exported function `decl` with an expando property assigned via a string-literal element access (`decl["B"] = 'foo'`), compiled with `--declaration`.
Clean: the .d.ts contains `export declare namespace decl { var B: string; }`.
Injected: the element-access expando is ignored, so the namespace with `B` is missing from the .d.ts.

Input: a blank target file c.ts; paste `console.log(abc);` (copied from b.ts, which imports `abc` from ./a) via language service `getPasteEdits`.
Clean: edits include the import of `abc` plus the pasted text. Injected: the paste replacement is registered before the early return and the import edit is mangled/duplicated, so the returned edits differ.

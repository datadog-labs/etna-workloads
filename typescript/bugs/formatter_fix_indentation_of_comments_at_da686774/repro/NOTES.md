Input: `if (true) {\n// test comment\n}` formatted via language service `getFormattingEditsForRange`, with the range covering only the comment (ending just before `}`).
Clean: the trailing comment is indented to 4 spaces (`    // test comment`).
Injected: the comment at the end of the range is not indented, so it stays at column 0.

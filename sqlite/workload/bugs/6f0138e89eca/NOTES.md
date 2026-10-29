repro.sql creates an FTS4 table holding '[one two three]' and asks for snippet() on a match of the first token.
Clean shell: `[<b>one</b> two three]`. Buggy shell: the leading `[` is dropped (`<b>one</b> two three]`).

Parses parenthesized `with` statements carrying `# type:` comments using `ast.parse(..., type_comments=True)`.
Clean prints `['int', 'int']`; buggy raises `SyntaxError: invalid syntax` because the parenthesized-with grammar rule doesn't accept a TYPE_COMMENT.

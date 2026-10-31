Compiles f-strings with a newline inside a format spec. Single-quoted ones must raise
"f-string: newlines are not allowed in format specifiers"; triple-quoted ones are valid.
Clean prints the SyntaxError for the first two cases; buggy compiles them successfully ("ok").

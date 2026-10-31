Folds two address lists with max_line_length=40 via the private header parser.
The second one has a comment containing a space, `<spy@example.org>(loremipsum dolorsitametconsecteturadipi)`.
Clean output keeps the parentheses: `...(loremipsum\n dolorsitametconsecteturadipi)`.
Buggy output drops them: `...loremipsum\n dolorsitametconsecteturadipi`. The comment is lost, and an unwrappable comment could inject headers.

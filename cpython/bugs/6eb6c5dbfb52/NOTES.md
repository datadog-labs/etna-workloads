Reproducer feeds truncated comments/declarations to HTMLParser and calls close(). Clean emits comment/decl events at EOF; buggy emits them as plain data.

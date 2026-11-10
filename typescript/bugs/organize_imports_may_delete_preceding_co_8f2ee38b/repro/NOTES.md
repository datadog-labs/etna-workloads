Organize Imports is run via the language service on a file with a doc comment and two `//` comments followed by three unused duplicate imports.
Clean build keeps the leading comments (doc comment, comment 1, comment 2) after removing the imports.
Injected build deletes the preceding comments along with the imports.

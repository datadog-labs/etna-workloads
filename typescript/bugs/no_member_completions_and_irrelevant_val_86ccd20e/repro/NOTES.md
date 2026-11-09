Input: a class with a property initializer lacking a semicolon (`property = "foo"`), followed by a newline and an empty line inside the class body; requests language-service completions there.
Clean: class member completions (e.g. `method`, `private`, `public`, `readonly`) are offered.
Injected: these member completions are missing (the newline check is skipped), so the printed list differs.

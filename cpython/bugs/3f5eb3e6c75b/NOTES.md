Creates a Maildir with dotfiles in new/ and cur/, then lists keys.
Clean: `[]` and `False`. Buggy: dotfiles are listed as messages (`['.foocur', '.foonew']`, `True`).

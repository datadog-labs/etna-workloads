Input: a language-service completion request right after `case E.` inside a `switch (u)` on an enum, with snippet/insert-text preferences enabled.
Clean: completions list only enum members (A, B). Injected: also offers the exhaustive-case snippet "case E.A: ..." because the right-of-dot check was removed.

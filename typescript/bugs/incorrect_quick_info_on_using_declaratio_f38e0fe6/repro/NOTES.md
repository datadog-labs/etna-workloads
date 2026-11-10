Input declares `using u = {...}` and asks the language service for quick info on `u`.
Clean: kind is "using" and display is "using u: {...}".
Injected: the using kind is missing, so it reports a different kind and display text (e.g. "var"/"let" form).

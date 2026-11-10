Language-service completions after `obj.` where the interface has a unique-symbol computed member `[mySymbol]` and a normal property.
Clean: the `mySymbol` entry (insertText `[mySymbol]`) has lower priority sortText (15, GlobalsOrKeywords).
Injected: it has the default sortText (11), same as normalProperty.

Parses a header containing \v, \f, \x1c-\x1e with the default email policy and
re-serializes it (normal and refold_source='all').
Clean: control characters are preserved in the output. Buggy: policy._fold uses
str.splitlines(), so they are treated as line breaks (folded to "\n " or collapsed to spaces).

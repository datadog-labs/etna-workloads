Throws into a generator that does `yield from` a custom (non-generator) iterator
with a `throw` method, and prints the stack frame names seen inside `throw`.
Clean: `['throw', 'g', '<module>']`; buggy: the generator frame `g` is missing
from the stack (not linked in), so the chain is incomplete.

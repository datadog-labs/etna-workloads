Reproducer: IntEnum/StrEnum members whose names shadow inherited int/str attributes
(`numerator`, `divisor`, `title`, `author`). Clean: `Number.divisor.numerator` is 1 and
`Book.author.title()` returns 'Author'. Buggy: enum's property no longer falls back to the
previous attribute/descriptor, so it returns the member (or raises) instead.

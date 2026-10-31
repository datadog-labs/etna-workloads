from enum import IntEnum, StrEnum

class Number(IntEnum):
    divisor = 1
    numerator = 2

for f in (lambda: Number.divisor.numerator, lambda: Number.numerator.divisor is Number.divisor):
    try:
        print(repr(f()))
    except Exception as e:
        print(type(e).__name__, e)

class Book(StrEnum):
    author = 'author'
    title = 'title'

for f in (lambda: Book.author.title(), lambda: Book.title.author is Book.author):
    try:
        print(repr(f()))
    except Exception as e:
        print(type(e).__name__, e)

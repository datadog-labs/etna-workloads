Reproducer calls typing.no_type_check on a class with classmethod/staticmethod; clean marks all three functions (True/True/True), buggy leaves classmethod/staticmethod unmarked (None/None/True).

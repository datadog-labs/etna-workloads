Creates a table whose column DEFAULT uses the aggregate form of max(), then inserts a row that needs the default.
Clean shell reports "unknown function: max()"; the buggy shell reports "misuse of aggregate function: max()" (the error message differs).

Compiles `lambda: a + b` and prints `co_positions()`. On the clean build the final
RETURN_VALUE has the lambda body's position (1, 1, 8, 13). On the buggy build it
has (1, 1, 0, 0), i.e. a position outside the lambda body.

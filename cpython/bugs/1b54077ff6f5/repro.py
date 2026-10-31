from typing import Literal
print(hash(Literal[1, 2]) == hash(Literal[2, 1]))
print(hash(Literal[1, 2, 3]) == hash(Literal[1, 2, 3, 3]))

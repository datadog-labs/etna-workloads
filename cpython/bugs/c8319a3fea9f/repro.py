from dataclasses import dataclass
from unittest.mock import create_autospec

@dataclass
class D:
    a: int

m = create_autospec(D, instance=True)
print(isinstance(m, D))
print(m.__class__)

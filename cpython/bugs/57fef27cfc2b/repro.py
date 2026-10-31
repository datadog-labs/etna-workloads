import typing
from typing import ForwardRef
print(repr(typing.evaluate_forward_ref(ForwardRef('None'))))

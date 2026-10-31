from typing import Union, Optional, Any

for t in (Union[str, list[int]], Union[list[int], int], Union[str, Any],
          Optional[list[int]], Optional[Any]):
    for obj in (42, None):
        try:
            print(t, obj, isinstance(obj, t))
        except TypeError as e:
            print(t, obj, 'TypeError', e)

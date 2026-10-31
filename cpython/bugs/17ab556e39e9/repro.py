from typing import NamedTuple
Point = NamedTuple("Point", zip(["x", "y"], [int, int]))
print(repr(Point(1, 2)))

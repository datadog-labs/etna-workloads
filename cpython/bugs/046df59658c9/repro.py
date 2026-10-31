from enum import Flag, global_enum

@global_enum
class NoName(Flag):
    ONE = 1
    TWO = 2

print(repr(str(NoName(0))))

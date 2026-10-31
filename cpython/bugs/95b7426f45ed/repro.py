from enum import Flag

class OpenAB(Flag):
    A = 1
    B = 2
    MASK = 255

A, B = OpenAB
print(repr(~OpenAB.MASK))
print(repr(~(A | B)))
print(repr(~OpenAB(0)))

Reproducer: INCRBYFLOAT foo by 1/41 then by -1/41 (values from the test), then GET foo.
Clean build returns `0`; buggy build (negative-zero normalization removed in util.c) returns `-0` for both the INCRBYFLOAT reply and GET.

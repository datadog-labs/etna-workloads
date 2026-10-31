import re
string = "x" * 2_500_000
p1 = r"(?<=((.{%d}){%d}){%d})"
print(re.search(p1 % (2**7, 2**7, 2**7), string).span())
for args in [(2**22, 1, 1), (2**22, 2**22, 1), (2**22, 2**22, 2**22), (2**31, 1, 1), (2**32, 1, 1)]:
    try:
        re.compile(p1 % args)
        print(args, "ok")
    except BaseException as e:
        print(args, type(e).__name__, e)

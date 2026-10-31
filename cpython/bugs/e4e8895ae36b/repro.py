import re
print(repr(re.fullmatch(r'a++b', 'ab')))
print(repr(re.fullmatch(r'(?:ab)*+c', 'abc')))
print(repr(re.fullmatch(r'(?s:(?>.*?\.).*)\z', "a.txt")))

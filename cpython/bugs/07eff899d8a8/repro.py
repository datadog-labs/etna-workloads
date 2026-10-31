from email import _header_value_parser as parser
from email import policy

p = policy.default.clone(max_line_length=10)
text = ("a" * 9) + ", " + ("b" * 20)
token = parser.get_address_list(text)[0]
try:
    print(repr(token.fold(policy=p)))
except Exception as e:
    print(type(e).__name__, e)

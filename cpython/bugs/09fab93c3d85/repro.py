from email import _header_value_parser as parser
from email import policy
to = 'x' * 66 + '@example.com, "Hübsch Kaktus" <beautiful@example.com>'
print(repr(parser.get_address_list(to)[0].fold(policy=policy.default)))

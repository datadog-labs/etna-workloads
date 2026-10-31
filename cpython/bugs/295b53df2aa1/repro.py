from email import policy
from email._header_value_parser import get_address_list
p = policy.default.clone(max_line_length=40)
to = '=?utf-8?q?A_v=C3=A9ry_long_name_with=2C_comma?= <to@example.com>'
al, _ = get_address_list(to)
print(repr(al.fold(policy=p)))

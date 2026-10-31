from email import _header_value_parser as parser
from email.policy import default
policy = default.clone(max_line_length=40)
to = '"Exfiltrator <spy@example.org> (unclosed comment?" <to@example.com>'
print(repr(parser.get_address_list(to)[0].fold(policy=policy)))

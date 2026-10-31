from email import _header_value_parser as parser
from email.policy import default
policy = default.clone(max_line_length=40)
for to in ['(loremipsumdolorsitametconsecteturadipi)<spy@example.org>',
           '<spy@example.org>(loremipsum dolorsitametconsecteturadipi)']:
    print(repr(parser.get_address_list(to)[0].fold(policy=policy)))

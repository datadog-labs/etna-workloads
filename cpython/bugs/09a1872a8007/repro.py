from email import _header_value_parser as p
dn = p.get_display_name(':Foo ')[0]
print(repr(dn.value))
print(repr(dn.display_name))

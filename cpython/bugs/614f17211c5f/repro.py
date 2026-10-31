from email.headerregistry import Address
try:
    a = Address(display_name='foo\r\nBcc: evil@example.com', username='wok', domain='example.com')
    print(repr(str(a)))
except ValueError as e:
    print('ValueError', e)

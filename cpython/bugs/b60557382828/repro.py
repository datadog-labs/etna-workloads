from email.headerregistry import Address
try:
    a = Address(addr_spec='wők@exàmple.com')
    print(repr(a.username), repr(a.domain), repr(a.addr_spec), repr(str(a)))
except Exception as e:
    print(type(e).__name__, e)

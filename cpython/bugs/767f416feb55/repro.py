import copy, pickle, ipaddress
a = ipaddress.IPv6Address('2001:db8::%scope')
for name, f in [('copy', copy.copy), ('deepcopy', copy.deepcopy),
                ('pickle', lambda x: pickle.loads(pickle.dumps(x)))]:
    b = f(a)
    print(name, repr(b), b == a, b.scope_id)

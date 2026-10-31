import ipaddress
try:
    ipaddress.IPv6Address("0:" * 10000 + "0")
except ipaddress.AddressValueError as e:
    print(str(e)[:80])

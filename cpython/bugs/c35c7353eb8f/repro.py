import configparser
cf = configparser.ConfigParser(allow_no_value=True,
                               interpolation=configparser.ExtendedInterpolation())
cf.read_string("[dummy]\na\nb = ${a}\n")
print(repr(cf["dummy"]["a"]))
print(repr(cf["dummy"]["b"]))

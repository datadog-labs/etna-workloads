import configparser
cp = configparser.ConfigParser()
try:
    cp.read_string("[s]\na = 1\n  2\na = 3\n")
except configparser.DuplicateOptionError as e:
    print(type(e).__name__)
print(repr(cp["s"]["a"]))

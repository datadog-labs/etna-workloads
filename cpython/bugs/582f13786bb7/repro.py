import pprint
class D(dict):
    def __repr__(self):
        return "custom" * 30
print(pprint.pformat(D({5: 6})))

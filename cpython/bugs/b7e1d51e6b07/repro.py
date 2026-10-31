import json
from json import encoder
from enum import Enum

class S(str):
    def __str__(self):
        return "StrSubclass"

class E(str, Enum):
    COLOR = "color"

for o in (S('ascii'), S('escape\n'), E.COLOR):
    print(json.dumps(o), json.dumps([o]), json.dumps({'key': o}))
print(json.dumps(S('nonascii:é'), ensure_ascii=False))

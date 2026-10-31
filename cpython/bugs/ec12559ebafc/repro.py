import json
import json.encoder

v = {b'invalid_key': False}
print(repr(json.dumps(v, skipkeys=True, indent=4)))
# pure-Python encoder
print(repr(''.join(json.encoder._make_iterencode.__globals__['JSONEncoder'](skipkeys=True, indent=4).iterencode(v, _one_shot=False))))

import json.encoder, gc
items = None

class BadDict(dict):
    def items(self):
        global items
        items = [("boom", object())]
        return items

def encode_str(obj):
    global items
    if items is not None:
        items.clear()
        items = None
        gc.collect()
    return '"x"'

enc = json.encoder.c_make_encoder(None, lambda o: "null", encode_str,
                                  None, ": ", ", ", False, False, True)
print(enc(BadDict(real=1), 0))

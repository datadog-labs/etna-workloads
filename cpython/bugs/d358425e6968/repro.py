import json.decoder, json.scanner
d = json.decoder.JSONDecoder()
d.scan_once = json.scanner.py_make_scanner(d)
for s in ["1０", "0.０", "0e０"]:
    try:
        print(repr(d.decode(s)))
    except json.JSONDecodeError as e:
        print("JSONDecodeError", e)

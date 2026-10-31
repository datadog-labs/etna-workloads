import plistlib, struct
d = b'bplist00' + b'\x4f\x13' + (1 << 40).to_bytes(8, 'big')
d += b'\x08' + struct.pack('>6xBBQQQ', 1, 1, 1, 0, 8 + 10)
with open('t.plist', 'wb') as f:
    f.write(d)
for buffering in (-1, 0):
    with open('t.plist', 'rb', buffering=buffering) as f:
        try:
            plistlib.load(f, fmt=plistlib.FMT_BINARY)
        except Exception as e:
            print(type(e).__name__)

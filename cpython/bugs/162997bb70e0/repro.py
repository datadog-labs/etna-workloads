import io, struct, zipfile

def make(extensible_data=b'', eocd_size=None):
    if eocd_size is None:
        eocd_size = 44 + len(extensible_data)
    name = b"test.txt"
    local = (b"PK\x03\x04\x14\x00\x00\x00\x00\x00\x00\x00!\x00\x9e%\xf5\xaf"
             + struct.pack("<LLHH", 8, 8, len(name), 4) + name
             + struct.pack("<HH", 1, 0) + b"test1234")
    central = (b"PK\x01\x02-\x03-\x00\x00\x00\x00\x00\x00\x00!\x00\x9e%\xf5\xaf"
               + struct.pack("<LLHH", 8, 8, len(name), 4)
               + b"\x00\x00\x00\x00\x00\x00\x00\x00\x80\x01"
               + struct.pack("<L", 0) + name + struct.pack("<HH", 1, 0))
    rec64 = (b"PK\x06\x06" + struct.pack("<Q", eocd_size)
             + b"-\x00-\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00"
             + b"\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00"
             + struct.pack("<QQ", len(central), len(local)) + extensible_data)
    loc = (b"PK\x06\x07\x00\x00\x00\x00"
           + struct.pack("<Q", len(local) + len(central)) + b"\x01\x00\x00\x00")
    eocd = (b"PK\x05\x06\x00\x00\x00\x00\x01\x00\x01\x00"
            + struct.pack("<LL", len(central), len(local)) + b"\x00\x00")
    return local + central + rec64 + loc + eocd

def attempt(label, data):
    try:
        with zipfile.ZipFile(io.BytesIO(data)) as zf:
            r = zf.read("test.txt")
    except Exception as e:
        r = type(e).__name__ + ": " + str(e)
    print(label, repr(r), zipfile.is_zipfile(io.BytesIO(data)))

attempt("bad size", make(eocd_size=0))
attempt("extensible", make(extensible_data=b'\xca\xfe\x04\x00\x00\x00data'))
attempt("prepended", b'prepended' + make(extensible_data=b'\xca\xfe\x04\x00\x00\x00data'))

import hmac, _hashlib
for h1 in (hmac.new(b"k", digestmod="sha256"), _hashlib.hmac_new(b"k", digestmod="sha256")):
    h2 = h1.copy()
    print(h1.name == h2.name, h1.digest_size == h2.digest_size, h1.block_size == h2.block_size)

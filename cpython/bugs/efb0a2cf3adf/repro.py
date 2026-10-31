import hashlib, hmac

cache = hashlib.__builtin_constructor_cache
cache['foo'] = hashlib.sha256
try:
    print(hmac.digest(b'key', b'message', 'foo').hex())
except Exception as e:
    print(type(e).__name__, e)
finally:
    cache.pop('foo')

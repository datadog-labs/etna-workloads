import codecs

# Error handler that advances less far than the error's "end", so the
# decoder's input pointer calculation must account for the remaining bytes
# correctly, or it will under-allocate / mis-point into the input buffer.
def forward_shorter_than_end(exc):
    if isinstance(exc, UnicodeDecodeError):
        return ('�', exc.start + 1)
    raise TypeError("don't know how to handle %r" % exc)

codecs.register_error("test.forward_shorter_than_end", forward_shorter_than_end)

result = b'\xd8\xd8\xd8\xd8\xd8\x00\x00\x00'.decode(
    'utf-16-le', 'test.forward_shorter_than_end')
print(repr(result))

"""
Reproducer for gh-143195: use-after-free in bytearray.hex(sep) when the
separator's __len__ is re-entrant and mutates the bytearray being hexlified.

bytearray.hex(sep) first computes argbuf/arglen pointing into the
bytearray's internal buffer, then calls len(sep) while building the
separated hex string. If len(sep) clears/frees the bytearray's buffer,
the fixed code protects against this by bumping self->ob_exports around
the call (which makes bytearray.clear() raise BufferError because the
buffer is "exported"). Without the fix, the buffer is freed out from
under the still-in-progress hex() call, causing a use-after-free.
"""

ba = bytearray(b'\xAA')


class S(bytes):
    def __len__(self):
        ba.clear()
        return 1


try:
    result = ba.hex(S(b':'))
except BufferError:
    print('BufferError')
else:
    print('no exception:', repr(result))

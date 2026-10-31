Feeds b'some data\r\n' to an asyncio.StreamReader and calls readuntil() with a bytearray separator.
Clean: returns b'some data\r\n' with an empty buffer. Buggy: the bytearray is treated as an iterable of separators (ints), so it raises an exception instead.

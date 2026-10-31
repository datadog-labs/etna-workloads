Flattens a message with a non-ASCII local-part under utf8=False. Clean raises HeaderWriteError; buggy silently RFC 2047-encodes the addr-spec.

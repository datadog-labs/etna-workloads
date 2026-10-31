Calls `email._header_value_parser.get_word` on a CFWS-only string. Clean raises HeaderParseError;
buggy (empty-value check removed) raises IndexError instead.

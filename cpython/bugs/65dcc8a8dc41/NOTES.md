Calls email._header_value_parser.get_encoded_word on an encoded word with unknown
CTE ('X'). Clean: raises HeaderParseError (printed). Buggy: KeyError escapes
(traceback, nonzero exit).

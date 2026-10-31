repro.py calls email._header_value_parser.get_msg_id('') . Clean raises HeaderParseError; buggy (missing 'value and' guard) raises IndexError. The script prints the exception type.

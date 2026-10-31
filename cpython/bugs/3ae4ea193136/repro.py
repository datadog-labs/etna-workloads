from email import _header_value_parser as parser, errors
try:
    parser.get_msg_id('')
except errors.HeaderParseError as e:
    print('HeaderParseError', e)
except Exception as e:
    print(type(e).__name__, e)

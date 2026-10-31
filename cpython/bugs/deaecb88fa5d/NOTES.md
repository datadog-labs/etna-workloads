Parses an 8bit message whose Content-Type uses an RFC 2231 encoded charset (`charset*=ansi-x3.4-1968''utf-8`) and prints `get_payload()`.
Clean: `'pöstal\n'` (charset decoded via get_content_charset). Buggy: get_param('charset') returns a tuple, so decode raises TypeError, which is not caught, or yields a wrong payload.

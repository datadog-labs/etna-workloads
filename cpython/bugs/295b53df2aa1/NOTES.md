Parses an address list containing an encoded word whose decoded text has a comma
(`=2C`) with `_header_value_parser.get_address_list`, then folds it at max_line_length=40.
Clean keeps the comma encoded (`=?utf-8?q?=2C?=`); buggy emits a raw `with,` in the
folded output, because the fold code no longer checks `vtext` tokens for specials.

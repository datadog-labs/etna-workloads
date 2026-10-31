Calls email._header_value_parser.get_group on an address group missing the final ';'.
Clean: returns the group with ';' appended and an InvalidHeaderDefect recorded.
Buggy: `value[0]` is evaluated on the empty string, raising IndexError instead of recording the defect.

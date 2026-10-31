Calls email._header_value_parser.get_msg_id on "<@domain>", "<[abrakadabra@microsoft.com]>" and "< @domain>".
Clean: HeaderParseError for the first two, a msg-id with an ObsoleteHeaderDefect for the third.
Buggy: IndexError (empty obs_local_part indexed) instead.

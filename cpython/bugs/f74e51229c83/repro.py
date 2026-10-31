from email import _header_value_parser as p
for s in ["<@domain>", "<[abrakadabra@microsoft.com]>", "< @domain>"]:
    try:
        m = p.get_msg_id(s)[0]
        print(repr(str(m)), [type(d).__name__ for d in m.all_defects])
    except Exception as e:
        print(type(e).__name__, e)

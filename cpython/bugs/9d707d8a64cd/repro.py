from email import message_from_string, policy

s = "Subject: Dummy subject\r\n: faulty header line\r\n\r\nbody\r\n"
try:
    msg = message_from_string(s, policy=policy.default.clone(raise_on_defect=True))
    print(repr(msg.defects))
except Exception as e:
    print(type(e).__name__, e)

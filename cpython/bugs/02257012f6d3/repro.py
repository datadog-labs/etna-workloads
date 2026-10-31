from email import message_from_string, policy
msg = message_from_string("Content-Type: multipart/mixed; charset=\"utf-8\"\n\nsample text\n", policy=policy.default)
try:
    print(repr(list(msg.iter_attachments())))
except Exception as e:
    print(type(e).__name__, e)

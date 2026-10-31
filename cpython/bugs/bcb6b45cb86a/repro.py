import email
msg = email.message_from_string(
    "Content-Disposition: attachment; "
    "filename*=\"ignored\"; "
    "filename*0*=\"utf-8''foo%20\"; "
    "filename*1*=\"bar.txt\"\n"
)
try:
    print(repr(msg.get_filename()))
except Exception as e:
    print(type(e).__name__, e)

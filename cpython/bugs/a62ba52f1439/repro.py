import email, email.policy
for pol in (email.policy.default, email.policy.compat32):
    for cte in ("base64 ", "base64 some text"):
        msg = email.message_from_string(
            f"Content-Transfer-Encoding: {cte}\n\nSGVsbG8uIFRlc3Rpbmc=\n", policy=pol)
        print(repr(cte), repr(msg.get_payload(decode=True)))

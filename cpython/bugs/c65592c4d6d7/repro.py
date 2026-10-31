import email.parser, email.policy

msg = """Content-Type: multipart/mixed; boundary=foo

--foo
Content-Type: text/plain

bar
--foo--
"""
m = email.parser.Parser(policy=email.policy.default).parsestr(msg, headersonly=True)
print(repr(m.defects))

import email, email.policy
source = 'Subject: one\v two\f three\x1c four\x1d five\x1e six\r\n\r\ntest body\r\n'
msg = email.message_from_string(source, policy=email.policy.default)
print(repr(msg['Subject']))
print(repr(msg.as_string()))
p = email.policy.default.clone(refold_source='all')
print(repr(msg.as_string(policy=p)))

import email.message, email.policy
p = email.policy.default.clone()
print(repr(p.fold('Subject', 'á')))

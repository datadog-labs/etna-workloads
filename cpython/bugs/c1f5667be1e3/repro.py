import email.policy
policy = email.policy.default.clone(max_line_length=20)
print(repr(policy.fold('Subject', 'ą' * 12)))

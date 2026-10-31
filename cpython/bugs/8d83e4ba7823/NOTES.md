Subclasses smtplib.SMTP to intercept sendmail() (no network) and calls send_message()
with a From header containing a display name. Clean: from_addr 'michael@example.com'.
Buggy: from_addr is the raw header value ('Michaël <michael@example.com>'), since the
getaddresses() step is removed.

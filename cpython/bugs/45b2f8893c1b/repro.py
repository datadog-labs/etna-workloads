import io
from email.message import EmailMessage
from email.generator import BytesGenerator
from email.headerregistry import Address
from email import policy

msg = EmailMessage()
msg["From"] = Address(addr_spec="foo@bar.com", display_name="Páolo")
msg["To"] = Address(addr_spec="bar@foo.com", display_name="Dinsdale")
msg["Subject"] = "Nudge nudge, wink, wink"
msg.set_content("oh boy, know what I mean, know what I mean?")
s = io.BytesIO()
BytesGenerator(s, policy=policy.SMTP).flatten(msg)
print(repr(s.getvalue()))

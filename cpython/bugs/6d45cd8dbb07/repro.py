from email import policy
from email.message import EmailMessage

for n in [0, None]:
    msg = EmailMessage(policy=policy.default.clone(max_line_length=n))
    msg["From"] = "a@ex.com"
    msg["To"] = "b@ex.com"
    msg["Subject"] = "S" * 100
    try:
        msg.set_content("B" * 100)
        print(repr(msg.as_bytes()))
    except Exception as e:
        print(n, type(e).__name__, e)

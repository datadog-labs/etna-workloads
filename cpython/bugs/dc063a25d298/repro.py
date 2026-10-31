import platform
u = platform.uname()
print(u._fields)
print(len(u._asdict()))

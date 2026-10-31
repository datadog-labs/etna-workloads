import os, sys
name = b'script_\xff_undecodable.py'
with open(name, 'wb') as f:
    f.write(b'print("Remote script executed successfully!")\n')
for p in [name, os.fsdecode(name)]:
    try:
        sys.remote_exec(os.getpid(), p)
        print("ok")
    except Exception as e:
        print(type(e).__name__)

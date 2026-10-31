import io, tarfile
fd = io.BytesIO()
tarfile.open(fileobj=fd, mode="w").close()
for mode in ("r|", "r"):
    fd.seek(0)
    with tarfile.open(fileobj=fd, mode=mode) as tf:
        try:
            print(mode, repr(tf.next()))
        except Exception as e:
            print(mode, type(e).__name__, e)

import tarfile

for repl in (b" foo=bar\n", b"0 \n", b"3 =\n", b"1000000 foo=bar\n",
             b"0 foo=bar\n", b"-12 foo=bar\n"):
    with tarfile.open("t.tar", "w", format=tarfile.PAX_FORMAT) as tar:
        t = tarfile.TarInfo()
        t.name = "pax"
        t.uid = 1
        t.pax_headers = {"foo": "bar"}
        tar.addfile(t)
    with open("t.tar", "rb") as f:
        data = f.read().replace(b"11 foo=bar\n", repl)
    with open("t.tar", "wb") as f:
        f.write(data)
    try:
        with tarfile.open("t.tar", "r:") as tf:
            print(repl, "OK", tf.getmembers()[0].pax_headers)
    except Exception as e:
        print(repl, type(e).__name__, e)

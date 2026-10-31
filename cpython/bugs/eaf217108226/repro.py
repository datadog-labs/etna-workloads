import pickletools
pickletools.dis(b"S'caf\\xe9'\n.")
pickletools.dis(b"U\x01\xe9.")

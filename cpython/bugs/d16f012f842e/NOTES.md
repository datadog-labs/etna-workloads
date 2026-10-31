repro.py: mbox.get_string(key, from_=True) must keep the stored 'From ' line. Clean prints True; buggy prints False (get_bytes isn't passed from_, so a synthetic 'From nobody <date>' line is used).

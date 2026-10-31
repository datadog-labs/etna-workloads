hook_compressed() on a non-compressed file in binary mode ('rb').
Clean: returns the open file, prints b'data\n'.
Buggy: encoding is forced to "locale" even for binary mode, so open() raises
ValueError: binary mode doesn't take an encoding argument.

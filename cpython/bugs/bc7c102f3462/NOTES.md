repro.py parses a TOML key with recursionlimit+2 parts. Clean raises RecursionError (MAX_KEY_PARTS check); buggy (check removed) parses it successfully and prints 'parsed'.

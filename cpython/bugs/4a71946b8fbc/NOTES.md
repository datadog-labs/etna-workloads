repro.py prints len(sys.flags): 18 on clean, 19 on buggy (injection makes gil index-addressable in the tuple).

repro.py calls sys.remote_exec(0, None) and sys.remote_exec(0, 123) and prints the exception type.
Clean: TypeError for both (the script argument is rejected by PyUnicode_FSConverter).
Buggy: the failure check is `< 0` instead of `== 0`, so the conversion error is ignored and it proceeds to a FileNotFoundError.

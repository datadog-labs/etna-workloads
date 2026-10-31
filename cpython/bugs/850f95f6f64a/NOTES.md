Reproducer: 10 threads each call a ThreadingMock 2000 times with a tiny switch interval, then print whether call_count == 20000 and len(call_args_list).
Clean: `True 20000`. Buggy: `False 20000` (call_count is a non-atomic `+= 1`, so updates are lost). Race-based, but with 20000 calls it failed in every buggy run I tried (4 runs including check.sh).

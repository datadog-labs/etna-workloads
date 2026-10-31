import sys, traceback
sys.last_exc = ValueError(42)
traceback.print_last(file=sys.stdout)

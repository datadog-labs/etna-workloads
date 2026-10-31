import _testcapi, sys
_testcapi.run_in_subinterp("[0]*%d" % sys.maxsize)
print("done")

import sys, runpy
sys.argv = ["inspect", "--details", "sys"]
try:
    runpy.run_module("inspect", run_name="__main__")
except SystemExit as e:
    print("exit", repr(e.code))

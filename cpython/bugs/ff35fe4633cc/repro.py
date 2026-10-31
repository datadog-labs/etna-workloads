import os, runpy, tempfile

for name in ["nonexistent_runpy_test_module", "sys.imp.eric", ".relative_name", "sys", "multiprocessing"]:
    try:
        runpy.run_module(name)
    except ImportError as exc:
        print(name, repr(exc.name))

with tempfile.TemporaryDirectory() as d:
    open(os.path.join(d, "not_main.py"), "w").close()
    try:
        runpy.run_path(d)
    except ImportError as exc:
        print("run_path", repr(exc.name))

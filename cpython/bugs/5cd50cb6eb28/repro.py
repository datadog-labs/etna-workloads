import linecache, traceback

fn = "repro_tmp.py"
with open(fn, "w") as f:
    f.write("# this line will be used during rendering")
linecache.updatecache(fn, {})

try:
    exec(compile("abcdef = 1 / 0 and 2.0", fn, "exec"))
except ZeroDivisionError as exc:
    s = traceback.TracebackException.from_exception(exc).stack
    print(s.format_frame_summary(s[1]))

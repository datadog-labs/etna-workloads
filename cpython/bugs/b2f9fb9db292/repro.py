import subprocess, sys, re
code = "import gc\ngc.set_debug(gc.DEBUG_STATS)\ngc.collect()\n"
err = subprocess.run([sys.executable, "-c", code], capture_output=True).stderr.decode()
print(bool(re.search(r"gc: done, .* unreachable, .* uncollectable, .* elapsed", err)))

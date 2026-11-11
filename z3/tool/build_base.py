#!/usr/bin/env python3
import os, sys, subprocess
sys.path.insert(0, os.path.dirname(__file__))
from z3lab import *
log = os.path.join(WORK, "logs", "base_build.log")
assert configure(BASE_SRC, BASE_BUILD, log)
st, secs = ninja(BASE_BUILD, log, jobs=14)
print(st, secs)
if st == "ok":
    subprocess.run(["chmod", "-R", "a-w", BASE_SRC, BASE_BUILD], check=True)
    # pristine manifest of base src for later verification
    subprocess.run(f"cd {BASE_SRC} && find . -type f -print0 | sort -z | xargs -0 sha256sum > {WORK}/base_src.sha256", shell=True, check=True)

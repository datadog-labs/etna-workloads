import os, subprocess, sys

# Single-character lines in a ._pth file are dropped by getpath's readlines().
os.symlink(sys.executable, "py")
with open("py._pth", "w") as f:
    f.write("\n".join([*sys.path, "a", "bb", "c"]) + "\n")
out = subprocess.run(["./py", "-S", "-c",
                      "import sys; print([os.path.basename(p) for p in sys.path[-3:]])"
                      .replace("os.path.basename(p)", "p.rpartition('/')[2]")],
                     capture_output=True, text=True)
print(out.stdout, out.stderr[-300:])

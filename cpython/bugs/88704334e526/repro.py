import os, shutil, pathlib, tempfile
t = tempfile.mkdtemp()
src = pathlib.Path(t, "source")
(src / "d").mkdir(parents=True)
(src / "d" / "f.txt").write_text("x")
def ign(s, names):
    print(type(s).__name__, type(names).__name__)
    return []
shutil.copytree(src, os.path.join(t, "dst"), ignore=ign)

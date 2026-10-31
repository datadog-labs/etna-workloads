import os, sys, modulefinder
os.mkdir("a")
open("a/b.py", "w").close()
with open("module.py", "w") as f:
    f.write("import a\nimport a.c\nimport blahblah\n")
mf = modulefinder.ModuleFinder(path=[os.getcwd()] + sys.path)
mf.run_script("module.py")
print(sorted(mf.modules))
print(sorted(mf.badmodules))

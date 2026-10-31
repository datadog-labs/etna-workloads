Runs pdb._pyrepl_available() (source extracted from pdb.py, since `import pdb` fails: the build
Lib's bdb.py is just `print(world)` in both interpreters) with PYTHON_BASIC_REPL=1 and then
unset with a fake _pyrepl.main having CAN_USE_PYREPL=True.
Clean prints False/True; buggy (inverted env check) prints False/False.

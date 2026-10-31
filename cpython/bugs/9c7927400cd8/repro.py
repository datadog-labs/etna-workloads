import os, tempfile

tempfile.tempdir = tempfile.gettempdirb()
print(type(tempfile.gettempdir()).__name__)
print(type(tempfile.gettempdirb()).__name__)
path = tempfile.mkdtemp()
os.rmdir(path)
print(type(path).__name__)

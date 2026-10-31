import pathlib
p2 = pathlib.PurePosixPath('b/', 'c:\\d')
print(repr(pathlib.PureWindowsPath(p2)))

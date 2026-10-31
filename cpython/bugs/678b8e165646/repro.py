from ctypes import Structure, LittleEndianStructure, BigEndianStructure, alignment

for base in (Structure, LittleEndianStructure, BigEndianStructure):
    class MyStructure(base):
        _align_ = 0
        _fields_ = []

    print(base.__name__, alignment(MyStructure), alignment(MyStructure()))

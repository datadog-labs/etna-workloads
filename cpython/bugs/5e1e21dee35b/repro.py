class M:
    def __init__(self):
        self.ba = bytearray(0x180)
    def __index__(self):
        self.ba.clear()
        self.new_ba = bytearray(0x180)
        self.ba.extend([0] * 0x180)
        return 0

m = M()
m.ba[m] = ord("?")
print(m.ba[0], m.new_ba == bytearray(0x180))

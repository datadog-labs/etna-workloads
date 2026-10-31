import sys, code, io
sys.excepthook = 1
c = code.InteractiveConsole()
c.push("1/0")
c.push("a = 123")
c.push("print(a)")
print("done")

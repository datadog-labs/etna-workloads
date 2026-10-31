import sys

count = 0

def tr(frame, event, arg):
    global count
    if event == "opcode":
        count += 1
    return tr

sys.settrace(tr)
sys._getframe().f_trace = tr
sys._getframe().f_trace_opcodes = True
a = 1
b = 2
sys.settrace(None)
print("opcode events seen:", count > 0)

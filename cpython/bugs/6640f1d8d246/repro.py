import sys

def func(output):
    x = None
    if x is None:
        output.append(3)
    else:
        output.append(5)
    output.append(6)

out = []
def tracer(frame, event, arg):
    if frame.f_code is not func.__code__:
        return None
    if event == 'line' and frame.f_lineno == 9:
        try:
            frame.f_lineno = 8
        except Exception as e:
            print(type(e).__name__, e)
        frame.f_trace = None
        sys.settrace(None)
    return tracer

sys.settrace(tracer)
func(out)
sys.settrace(None)
print(out)

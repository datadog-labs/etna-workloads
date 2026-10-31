import sys, traceback

raised = False
def error_once(frame, event, arg):
    global raised
    if not raised:
        raised = True
        raise Exception
    return error_once

def f():
    try:
        sys._getframe().f_trace = error_once
        sys.settrace(error_once)
        len([])
    except Exception as ex:
        tb = ex.__traceback__
        names = []
        while tb:
            names.append(tb.tb_frame.f_code.co_name)
            tb = tb.tb_next
        print(names)
    finally:
        sys.settrace(None)

f()

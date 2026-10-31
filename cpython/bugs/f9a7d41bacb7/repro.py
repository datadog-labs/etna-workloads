import traceback

def inner():
    return list(traceback.walk_stack(None))

frames = inner()
print(frames[0][0].f_code.co_name)

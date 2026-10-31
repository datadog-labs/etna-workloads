import traceback

def exc():
    try:
        raise Exception(42)
    except* Exception as e:
        raise

try:
    exc()
except BaseException as e:
    print([f.name for f in traceback.extract_tb(e.__traceback__)])

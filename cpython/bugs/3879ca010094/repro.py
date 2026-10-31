class BadEG(ExceptionGroup):
    def split(self, *args):
        return "not a tuple"

try:
    try:
        raise BadEG("eg", [ValueError(1)])
    except* ValueError:
        pass
except BaseException as e:
    print(type(e).__name__, e)

from _pyrepl.readline import _ReadlineWrapper

class R:
    pos = 3
    def get_unicode(self):
        return "abc"

w = _ReadlineWrapper(f_in=None, f_out=None, reader=R())
print(repr(w.get_line_buffer()))

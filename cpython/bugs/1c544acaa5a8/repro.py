from urllib.request import OpenerDirector, BaseHandler

class H(BaseHandler):
    def open(self, *a): pass
    def _open(self, *a): pass
    def error(self, *a): pass

o = OpenerDirector()
o.add_handler(H())
print(sorted(o.handle_open), sorted(o.handle_error))

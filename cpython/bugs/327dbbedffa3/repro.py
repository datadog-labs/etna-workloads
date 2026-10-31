import logging
class H(logging.Handler):
    def emit(self, r):
        print(r.getMessage(), hasattr(r, 'foo'))
lg = logging.getLogger('x')
lg.addHandler(H())
a = logging.LoggerAdapter(lg, merge_extra=True)
a.critical('with extra', extra={'foo': '1'})
try:
    a.critical('no extra')
except Exception as e:
    print(type(e).__name__, e)

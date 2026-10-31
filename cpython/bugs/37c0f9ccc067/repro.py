import logging, logging.handlers, sys

target = logging.StreamHandler(sys.stdout)
target.setFormatter(logging.Formatter('%(levelname)s %(message)s'))
mem = logging.handlers.MemoryHandler(10, logging.WARNING, target, False)
lg = logging.getLogger('x')
lg.propagate = False
lg.setLevel(logging.DEBUG)
lg.addHandler(mem)
lg.debug('buffered')
logging.shutdown(handlerList=[logging.weakref.ref(mem)])
print('done')

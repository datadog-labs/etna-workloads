import logging.config, queue

class MyQueue:
    def put_nowait(self, x): pass
    def get(self): pass

try:
    logging.config.dictConfig({
        'version': 1,
        'handlers': {'h': {'class': 'logging.handlers.QueueHandler', 'queue': MyQueue()}},
        'root': {'handlers': ['h']},
    })
    print(type(logging.getLogger().handlers[0].queue).__name__)
except Exception as e:
    print(type(e).__name__, e)

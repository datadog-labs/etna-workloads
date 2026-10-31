import logging, logging.config, logging.handlers, queue

class CustomQueueHandler(logging.handlers.QueueHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(queue.Queue())
        self.custom_kwargs = kwargs

logging.config.dictConfig({
    'version': 1,
    'handlers': {'custom': {'class': CustomQueueHandler, 'foo': 'bar'}},
    'root': {'level': 'DEBUG', 'handlers': ['custom']},
})
print(repr(logging.getHandlerByName('custom').custom_kwargs))

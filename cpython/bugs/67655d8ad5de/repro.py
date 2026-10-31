import logging, logging.config, queue
try:
    logging.config.dictConfig({
        'version': 1,
        'handlers': {'h': {'class': 'logging.handlers.QueueHandler',
                           'queue': queue.Queue()}},
        'root': {'handlers': ['h']},
    })
    print(type(logging.getLogger().handlers[0]).__name__)
except ValueError as e:
    print('ValueError:', e, '/', e.__cause__)

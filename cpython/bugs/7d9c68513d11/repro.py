import logging.config
import multiprocessing
import queue

calls = []
multiprocessing.Manager = lambda *a, **k: calls.append(1)

config = {
    'version': 1,
    'handlers': {'h': {'class': 'logging.handlers.QueueHandler', 'queue': queue.Queue()}},
    'root': {'handlers': ['h']},
}
logging.config.dictConfig(config)
print(len(calls))

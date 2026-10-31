import logging.handlers, queue
l = logging.handlers.QueueListener(queue.Queue())
l.start()
try:
    l.start()
    print("no error")
except RuntimeError as e:
    print("RuntimeError:", e)

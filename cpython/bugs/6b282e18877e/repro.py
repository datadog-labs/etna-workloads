import logging.handlers, queue
q = queue.Queue()
l = logging.handlers.QueueListener(q)
l.start()
l.stop()
print(q.unfinished_tasks)

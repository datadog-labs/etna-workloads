Reproducer calls QueueListener.start() twice. Clean raises RuntimeError('Listener already started'); buggy silently starts a second thread.

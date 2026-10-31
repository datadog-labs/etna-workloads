import logging.config, multiprocessing

if __name__ == '__main__':
    with multiprocessing.get_context('fork').Manager() as m:
        q = m.Queue()
        try:
            logging.config.dictConfig({
                'version': 1,
                'handlers': {'h': {'class': 'logging.handlers.QueueHandler', 'queue': q}},
                'root': {'handlers': ['h'], 'level': 'DEBUG'},
            })
            logging.getLogger().info("text")
            print(q.get(timeout=10).getMessage())
        except Exception as e:
            print(type(e).__name__, e)

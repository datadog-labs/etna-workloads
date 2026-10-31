repro.py passes a multiprocessing Manager().Queue() proxy as the 'queue' of a QueueHandler in logging.config.dictConfig, then logs a message.
Clean: the proxy is accepted (duck-typed put_nowait/get check) and prints "text".
Buggy: the check only accepts real queue/MPQueue instances, so it raises ValueError "Unable to configure handler 'h'".

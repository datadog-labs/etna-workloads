repro.py passes a duck-typed queue (only put_nowait/get) as the 'queue' of a QueueHandler in logging.config.dictConfig.
Clean: configures fine, prints "MyQueue". Buggy: _is_queue_like_object returns False for anything but real queue types, so it prints "ValueError Unable to configure handler 'h'".

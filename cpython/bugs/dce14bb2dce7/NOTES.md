Reproducer: configures a QueueHandler subclass via logging.config.dictConfig with an extra key `foo='bar'`
and prints the kwargs the handler's __init__ received.
Clean: `{'foo': 'bar'}`. Buggy: `{}` (kwargs are dropped by _configure_queue_handler).

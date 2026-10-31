import logging, logging.config
from collections import namedtuple

class H(logging.StreamHandler):
    def __init__(self, resource):
        super().__init__()
        self.resource = resource

Resource = namedtuple('Resource', ['type', 'labels'])
logging.config.dictConfig({
    'version': 1,
    'handlers': {'h': {'()': H, 'resource': Resource(type='my_type', labels=['a'])}},
    'root': {'level': 'INFO', 'handlers': ['h']},
})
print(type(logging.getLogger().handlers[0].resource).__name__)

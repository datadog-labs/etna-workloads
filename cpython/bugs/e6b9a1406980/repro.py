import sys
import _testcapi
from xml.parsers import expat

parser = expat.ParserCreate()
parser.buffer_text = True
before = sys.getrefcount(parser)
_testcapi.set_nomemory(1, 10)
raised = False
try:
    parser.ExternalEntityParserCreate(None)
except MemoryError:
    raised = True
finally:
    _testcapi.remove_mem_hooks()
print(raised)
print(sys.getrefcount(parser) - before)

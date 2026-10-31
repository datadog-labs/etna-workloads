import logging
from unittest.mock import patch

for ns in (1_677_902_297_100_000_000, 1_677_903_920_999_998_503, 1_677_903_920_000_998_503):
    with patch('time.time_ns', return_value=ns), patch('time.time', return_value=ns / 1e9):
        r = logging.makeLogRecord({'msg': 'test'})
    print(ns, r.msecs)

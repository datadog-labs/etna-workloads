import sys
import ensurepip

calls = []
ensurepip._run_pip = lambda *a, **k: calls.append(a) or 0
sys.modules['zlib'] = None
try:
    ensurepip.bootstrap()
except ModuleNotFoundError as e:
    print('ModuleNotFoundError:', e)
print('run_pip called:', bool(calls))

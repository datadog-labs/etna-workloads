repro.py calls None.__ne__ directly with None, 0 and "abc".
Clean: False, NotImplemented, NotImplemented. Buggy: NotImplemented for all three, so None.__ne__(None) wrongly returns NotImplemented instead of False (NoneType has no tp_richcompare).

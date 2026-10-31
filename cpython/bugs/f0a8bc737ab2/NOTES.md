Calls statistics.pstdev/stdev with inf/nan inputs. Clean: raises ValueError
("inf or nan encountered in data"). Buggy: a different exception (AttributeError from
mss.numerator) or a wrong result is produced instead of ValueError.

import statistics, math
for f in (statistics.pstdev, statistics.stdev):
    for data in ([1.0, math.inf], [1.0, math.nan]):
        try:
            print(repr(f(data)))
        except Exception as e:
            print(type(e).__name__, e)

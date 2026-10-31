import pickle, trace
with open('infile', 'wb') as f:
    pickle.dump(({}, {}, {'caller': 1}), f, protocol=1)
results = trace.CoverageResults({}, {}, 'infile', {})
print(repr(results.callers))

repro.py builds a trace.CoverageResults with a pickled infile that contains callers.
Clean prints {'caller': 1}. Buggy raises TypeError, because the nested CoverageResults call passes callers positionally, so it lands in the infile slot.

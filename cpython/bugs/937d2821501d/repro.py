import csv, io
try:
    print(list(csv.reader(['a   b', '  a  ', '  ', ''], delimiter=' ', skipinitialspace=True)))
except Exception as e:
    print(type(e).__name__, e)
s = io.StringIO()
try:
    csv.writer(s, delimiter=' ', skipinitialspace=True).writerow(['', ''])
    print(repr(s.getvalue()))
except Exception as e:
    print(type(e).__name__, e)

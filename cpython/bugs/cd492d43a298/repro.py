import csv, io
r = csv.DictReader(io.StringIO("1,2,3\r\n"), iter(["a", "b", "c"]))
print(type(r.fieldnames).__name__)
print(list(r))
w = csv.DictWriter(io.StringIO(), iter(["a", "b", "c"]))
print(w.fieldnames)
w.writeheader()
w.writerow({"a": 1, "b": 2, "c": 3})

import gc, time
lst = []
r = time.gmtime(0).__replace__(tm_year=lst)
lst.append(r)
print(gc.is_tracked(r))

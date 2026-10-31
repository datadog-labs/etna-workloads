import _interpchannels as ch
a = ch.create(); b = ch.create(); c = ch.create()
ch.close(b, force=True)
print(len(ch.list_all()))

import mmap
ps = mmap.PAGESIZE
with mmap.mmap(-1, ps) as m:
    try:
        m.resize(2 * ps)
        print("resized", len(m))
    except Exception as e:
        print(type(e).__name__)
with mmap.mmap(-1, 2 * ps) as m:
    m.resize(ps // 2)
    print(len(m))
    try:
        m.resize(2 * ps)
        print("resized", len(m))
    except Exception as e:
        print(type(e).__name__)

import timeit
for s in ['', '# comment', '  pass']:
    try:
        timeit.Timer(stmt=s)
        print(repr(s), 'ok')
    except SyntaxError as e:
        print(repr(s), 'SyntaxError')

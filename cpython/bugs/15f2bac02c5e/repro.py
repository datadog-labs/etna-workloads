from concurrent import interpreters
interp = interpreters.create()
interp.exec("""if True:
    comp = [str(i) for i in range(10)]
    print(''.join(comp))
""")
interp.close()

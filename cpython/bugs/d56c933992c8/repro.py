def f():
    try:
        yield
    except GeneratorExit:
        return 0

gen = f()
gen.send(None)
print(repr(gen.close()))
print(repr(gen.close()))

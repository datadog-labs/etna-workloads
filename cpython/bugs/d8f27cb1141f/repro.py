f = eval("lambda: a + b")
print(list(f.__code__.co_positions()))

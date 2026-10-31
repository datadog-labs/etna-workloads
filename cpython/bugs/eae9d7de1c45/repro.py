import inspect

ge = (x
      for x in range(3)
      if x)
print(inspect.getsource(ge.gi_code))

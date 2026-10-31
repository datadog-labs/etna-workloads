import types
cases = [
"""
def report_error():
    pass
try:
    [0 for name_2 in unique_name_0 if (lambda: name_2)]
except:
    pass
annotated_name: 0
""",
"""
class Generic:
    pass
annotated_name: 0
try:
    [0 for name_2 in [[0]] for unique_name_1 in unique_name_2 if (lambda: name_2)]
except:
    pass
""",
]
for code in cases:
    mod = types.ModuleType("m")
    exec(code, mod.__dict__)
    print(mod.__annotations__)

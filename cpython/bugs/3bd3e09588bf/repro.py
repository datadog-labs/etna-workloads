code = "from __future__ import barry_as_FLUFL;2 {0} 3"
try:
    compile(code.format('<>'), '<BDFL test>', 'exec')
    print("<> ok")
except SyntaxError as e:
    print("<> error:", e)
try:
    compile(code.format('!='), '<FLUFL test>', 'exec')
    print("!= ok")
except SyntaxError as e:
    print("!= error:", e)

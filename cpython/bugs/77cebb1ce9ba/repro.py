import subprocess, sys
with open('main.py', 'w') as f:
    f.write('print("hello")\n')
commands = """filename = $_frame.f_code.co_filename
f = open(filename, "w")
f.write("print('goodbye')")
import time; time.sleep(1)
f.close()
restart
quit
"""
p = subprocess.run([sys.executable, '-m', 'pdb', 'main.py'], input=commands,
                   capture_output=True, text=True)
print("was edited" in p.stdout)

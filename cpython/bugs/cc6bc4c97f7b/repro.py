import array, subprocess, sys

data = array.array('i', [0x64306f66] * 5000)
p = subprocess.Popen([sys.executable, "-c",
                      "import sys; sys.stdout.buffer.write(sys.stdin.buffer.read())"],
                     stdin=subprocess.PIPE, stdout=subprocess.PIPE)
out, err = p.communicate(memoryview(data))
print(len(out), len(data.tobytes()), out == data.tobytes())

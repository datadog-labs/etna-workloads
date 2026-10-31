import filecmp, os
os.mkdir('d1'); os.mkdir('d2')
with open('d1/f', 'w') as f: f.write('x')
with open('d2/f', 'w') as f: f.write('x')
for name in ['\x00', 'f\x00']:
    try:
        print(repr(filecmp.cmpfiles('d1', 'd2', [name])))
    except Exception as e:
        print(type(e).__name__, e)

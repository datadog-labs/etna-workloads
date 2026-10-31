import io, tokenize

def run(lines):
    it = iter(lines)
    try:
        print(repr(tokenize.detect_encoding(lambda: next(it, b''))))
    except SyntaxError as e:
        print('SyntaxError', e)

run([b'#coding:iso-8859-15 \xa4\n', b'print(x)\n'])
run([b'#coding:ascii \xc3\xa4\n', b'print(x)\n'])
run([b'#!/home/\xa4/bin/python\n', b'#coding:iso-8859-15\n', b'x\n'])
run([b'#coding:iso8859-15\x00\n', b'\n'])

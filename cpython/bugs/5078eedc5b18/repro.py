try:
    eval('f"{' * 200 + '}"' * 200)
except SyntaxError as e:
    print(e.msg)

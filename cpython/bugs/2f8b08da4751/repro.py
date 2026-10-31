for src in ["f'{1:d\n}'", "f'__{\n 1:d\n}__'", "f'''{1:d\n}'''"]:
    try:
        compile(src, "<string>", "exec")
        print("ok")
    except SyntaxError as e:
        print("SyntaxError:", e.msg)

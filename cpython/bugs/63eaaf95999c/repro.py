for src in ["class i: [__classdict__ for x in y]",
            "class i: [__conditional_annotations__ for x in y]",
            "class i: [lambda: __conditional_annotations__ for x in y]"]:
    try:
        exec(src, {})
    except BaseException as e:
        print(type(e).__name__)

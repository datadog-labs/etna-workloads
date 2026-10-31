for code in ["from .__future__ import spam",
             "from __future__ import print_function\nfrom ...__future__ import ham",
             "from .__future__ import nested_scopes\nfrom __future__ import barry_as_FLUFL"]:
    try:
        exec(code)
    except BaseException as e:
        print(type(e).__name__, e)
    else:
        print("no error")

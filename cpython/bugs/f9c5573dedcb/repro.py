import re
for p in ('((x)|y|z)*+', '((x)|y|z){3}+', '((x)|y|z){3,}+'):
    try:
        print(p, re.match(p, 'xyz').groups())
    except BaseException as e:
        print(p, type(e).__name__, e)

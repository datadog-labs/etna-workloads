import pyclbr
try:
    print(pyclbr.readmodule_ex('doesnotexist'))
except Exception as e:
    print(type(e).__name__, e)

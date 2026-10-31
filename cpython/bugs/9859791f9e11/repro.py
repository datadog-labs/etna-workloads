import _testcapi

code = """if 1:
    import threading, time
    threading.Thread(target=lambda: time.sleep(100), daemon=True).start()
"""
_testcapi.run_in_subinterp(code)
print("done")

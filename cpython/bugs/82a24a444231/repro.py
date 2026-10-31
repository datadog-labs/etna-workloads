import webbrowser

b = webbrowser.GenericBrowser("/nonexistent-browser-cmd")
try:
    print(repr(b.open("--key=val http://example.com")))
except ValueError as e:
    print("ValueError:", e)

import webbrowser
b = webbrowser.Chrome("chrome-nonexistent-cmd")
for url, new in [('%action--incognito', 0), ('%action', 1)]:
    try:
        b.open(url, new=new)
        print("no error")
    except ValueError as e:
        print("ValueError")

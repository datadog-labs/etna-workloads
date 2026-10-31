import zipfile
with zipfile.ZipFile("t.zip", "w") as z:
    z.writestr("a.txt", "123")
    z.writestr("b.txt", "456")
with zipfile.ZipFile("t.zip") as z:
    with z.open("a.txt") as a, z.open("b.txt") as b:
        print(a.read(1))
        print(b.seek(1))
        print(b.read(1))

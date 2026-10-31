import plistlib
from io import BytesIO

fp = BytesIO()
w = plistlib._PlistWriter(fp, indent=b'\t   ')
w.write([{'bytes': bytes(range(50))}])
print(fp.getvalue().decode())

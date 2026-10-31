import xml.etree.ElementTree as ET
for f in (lambda: ET.ElementTree(""), lambda: ET.ElementTree(ET.ElementTree()),
          lambda: ET.ElementTree()._setroot("")):
    try:
        f(); print("no error")
    except TypeError as e:
        print("TypeError", e)

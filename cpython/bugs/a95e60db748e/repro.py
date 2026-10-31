import xml.etree.ElementTree as ET

root = ET.Element('foo')
sub = ET.SubElement(root, 'bar')
for val in ["", 0, False, [], (), {}]:
    sub.text = val
    print(repr(val), repr(root.findtext('./bar')))

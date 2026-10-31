from xml.dom.minidom import parseString
dom = parseString('<?xml version="1.0" ?><root><node><![CDATA[</data>]]></node></root>')
print(repr(dom.toprettyxml()))

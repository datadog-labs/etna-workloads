from xml.dom.minidom import Document
dom = Document()
elem = dom.appendChild(dom.createElement('elem'))
elem.setAttribute("a", '&<>"')
elem.setAttribute("ws", "\t\n\r ")
elem.appendChild(dom.createTextNode('&<>"\r'))
print(repr(dom.toxml()))

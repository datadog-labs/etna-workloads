Constructs ElementTree("") / ElementTree(ElementTree()) and calls _setroot("").
Clean raises TypeError ("expected an Element, not ..."); buggy accepts silently and prints "no error".

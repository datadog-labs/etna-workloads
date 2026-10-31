import json, pydoc, warnings

with warnings.catch_warnings(record=True) as w:
    warnings.simplefilter("always")
    text = pydoc.render_doc(json)
    print("VERSION" in text, [str(x.message) for x in w])

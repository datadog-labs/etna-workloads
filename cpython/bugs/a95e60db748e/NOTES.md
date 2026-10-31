Sets `Element.text` to falsey non-None values (0, False, [], ...) and calls `findtext('./bar')`.
Clean returns the value unchanged; the buggy build returns `''` for every falsey value (`elem.text or ""`).

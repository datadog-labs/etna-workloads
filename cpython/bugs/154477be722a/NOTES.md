Builds a minidom document with attribute values containing quotes/whitespace and text containing `"` and `\r`, then prints toxml().
Clean: attributes escape `"` as &quot; and whitespace as &#9;/&#10;/&#13;; text keeps `"` and `\r` literal. Buggy: the old behaviour (whitespace unescaped in attributes, `"` escaped in text).

Feeds `<script>a</script foo>b` to HTMLParser. Clean: the closing tag `</script foo>` ends CDATA mode
(`end script`, then data 'b'). Buggy: the regex only matches `</script>` (with optional whitespace),
so the script never closes and the rest is treated as script data.

from html.parser import HTMLParser

class P(HTMLParser):
    def handle_starttag(self, tag, attrs): print('start', tag)
    def handle_endtag(self, tag): print('end', tag)
    def handle_data(self, data): print('data', repr(data))

p = P()
p.feed('<script>a</script foo>b')
p.close()

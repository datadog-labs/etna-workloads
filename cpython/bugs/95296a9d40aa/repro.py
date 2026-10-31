from html.parser import HTMLParser

class P(HTMLParser):
    def __init__(self, **kw):
        super().__init__(**kw)
        self.ev = []
    def handle_data(self, d): self.ev.append(('data', d))
    def handle_charref(self, n): self.ev.append(('charref', n))
    def handle_entityref(self, n): self.ev.append(('entityref', n))

for src in ['&#123 &lt;', '&#123', '&gt', '&undefined']:
    p = P(convert_charrefs=False)
    p.feed(src)
    p.close()
    print(repr(src), p.ev)

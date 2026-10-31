from html.parser import HTMLParser

class P(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ev = []
    def handle_comment(self, d): self.ev.append(('comment', d))
    def handle_decl(self, d): self.ev.append(('decl', d))
    def handle_data(self, d): self.ev.append(('data', d))

for s in ['<!--abc', '<!--abc--', '<!doctype html', '<!x', '</!x', '<', '<!-- a']:
    p = P()
    p.feed(s)
    p.close()
    print(repr(s), p.ev)

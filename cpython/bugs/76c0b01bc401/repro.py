from html.parser import HTMLParser

class P(HTMLParser):
    def handle_comment(self, d): print('comment', repr(d))
    def unknown_decl(self, d): print('decl', repr(d))

for s in ['<![CDATA[x]]>', '<![if foo]>', '<![endif]>']:
    p = P(convert_charrefs=False)
    p.feed(s)
    p.close()
    print('--')

from html.parser import HTMLParser

class P(HTMLParser):
    def handle_starttag(self, tag, attrs): print('starttag', tag, attrs)
    def handle_endtag(self, tag): print('endtag', tag)
    def unknown_decl(self, data): print('unknown decl', repr(data))
    def handle_comment(self, data): print('comment', repr(data))
    def handle_data(self, data): print('data', repr(data))

p = P(convert_charrefs=False)
p._support_cdata = True
p.feed('<svg><text y="100"><![CDATA[a]] >b]]></text></svg>')
p.close()

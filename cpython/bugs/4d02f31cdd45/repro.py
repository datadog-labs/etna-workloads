from html.parser import HTMLParser

class P(HTMLParser):
    def handle_starttag(self, tag, attrs): print("starttag", tag, attrs)
    def handle_endtag(self, tag): print("endtag", tag)
    def handle_data(self, data): print("data", repr(data))

p = P()
p.feed("<title>Egg &amp; Spam</title><textarea>a &lt; <b></textarea>")
p.close()

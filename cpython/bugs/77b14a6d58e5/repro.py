from html.parser import HTMLParser
class P(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print(attrs)
P().feed('<a x="&centz" y="&cent=z" z="&cent z">')

from xmlrpc.server import DocXMLRPCServer
import re

serv = DocXMLRPCServer(("localhost", 0), logRequests=False)
try:
    serv.set_server_title('test_title<script>')
    html = serv.generate_html_documentation()
    print(re.search(r'<title>(.+?)</title>', html).group())
finally:
    serv.server_close()

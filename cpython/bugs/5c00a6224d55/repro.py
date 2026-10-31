import http.client
import urllib.request

http.client.HTTPConnection.debuglevel = 5
print(urllib.request.HTTPHandler()._debuglevel)
http.client.HTTPSConnection.debuglevel = 4
print(urllib.request.HTTPSHandler()._debuglevel)

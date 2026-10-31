Reproducer: HTTPRedirectHandler.redirect_request on a HEAD request.
Clean prints HEAD; buggy prints GET (HEAD upgraded to GET on redirect).

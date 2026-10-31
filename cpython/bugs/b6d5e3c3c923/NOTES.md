Reproducer: extracts a cookie `foo=bar; domain=localhost` from a response for http://localhost into a CookieJar.
Clean: 1 cookie stored under ".localhost". Buggy: the cookie is rejected (0 cookies, empty jar),
because the injected check requires domain == ".local" instead of allowing erhn ending in ".local".

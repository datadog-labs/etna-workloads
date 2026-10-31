DOMBuilder.parse() with a DOMInputSource that only has systemId set (urlopen mocked).
Clean: opens the systemId and parses it, printing 'html'. Buggy: the check uses
options.systemId instead of input.systemId, so no stream is opened and parsing fails
with an exception instead.

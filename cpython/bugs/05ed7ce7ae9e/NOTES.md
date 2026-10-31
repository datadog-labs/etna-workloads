repro.py sets a tunnel with an invalid host and headers containing CRLF, then calls _tunnel(). Clean raises ValueError for each; buggy sends them unvalidated (header injection).

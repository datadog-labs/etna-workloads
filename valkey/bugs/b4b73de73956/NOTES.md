Starts a single cluster-enabled server and runs CONFIG SET on cluster-announce-ip and
cluster-announce-human-nodename with values containing space, comma, '=', '"' and newline.
Clean build rejects each with "invalid character" errors; the buggy build (weaker
isValidAuxChar, no cluster-announce-ip validator) replies OK to all of them.

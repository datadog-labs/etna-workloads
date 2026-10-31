Calls email.utils.getaddresses with a quoted real name containing a comma.
Clean: returns the three parsed (name, addr) pairs. Buggy: the comma inside the
quotes is counted as an address separator, so the count check fails and the
result is [('', '')].

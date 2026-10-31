Splits a URL with a scoped IPv6 host (`%tESt` zone) and prints `.hostname` for str and bytes.
Clean: address lowercased but zone preserved (`fe80::...%tESt`). Buggy: whole hostname lowercased, zone becomes `%test`.

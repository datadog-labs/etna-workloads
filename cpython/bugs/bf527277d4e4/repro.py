import ssl, warnings
ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
with warnings.catch_warnings(record=True) as w:
    warnings.simplefilter("always")
    ctx.options |= ssl.OP_NO_TLSv1_3
print([str(x.message) for x in w])

from email.headerregistry import HeaderRegistry
a = HeaderRegistry()('Content-Disposition', 'attachment; 0*00="foo"')
print([type(d).__name__ for d in a.defects])

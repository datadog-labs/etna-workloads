import gettext, warnings, os

t = gettext.GNUTranslations()
t._catalog = {('s', 0): 'S', ('s', 1): 'P'}
t.plural = gettext.c2py('n != 1')

with warnings.catch_warnings(record=True) as w:
    warnings.simplefilter('always')
    t.ngettext('s', 'p', 1.0)
print([(os.path.basename(x.filename), x.lineno) for x in w])

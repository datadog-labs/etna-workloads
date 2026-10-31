from xml.sax import make_parser
from xml.sax.handler import EntityResolver, feature_external_ges

class Rec(EntityResolver):
    def __init__(self):
        self.entities = []
    def resolveEntity(self, publicId, systemId):
        self.entities.append((publicId, systemId))
        return super().resolveEntity(publicId, systemId)

p = make_parser()
print(p.getFeature(feature_external_ges))
r = Rec()
p.setEntityResolver(r)
p.feed('<!DOCTYPE external SYSTEM "unsupported://non-existing">\n')
p.feed('<doc />')
p.close()
print(r.entities)

type ('node, 'a) extension = 'a
  constraint 'a = < node : 'node; self : 'a >;;
type 'ext node = < > constraint 'ext = ('ext node, 'self) extension;;

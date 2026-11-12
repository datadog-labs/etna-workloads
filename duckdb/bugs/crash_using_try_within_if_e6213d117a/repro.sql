select if(a, try(b), null) x
from values (0, null), (1, 1), (1, 1) t(a, b);

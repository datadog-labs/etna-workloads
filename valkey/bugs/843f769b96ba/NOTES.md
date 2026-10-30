repro.sh runs ZADD with GT/LT + INCR where the score is not updated, and with inf scores.
Clean build replies nil when the GT/LT condition blocks the increment. The buggy build replies with the would-be score (e.g. 6, 4) and gives NaN errors on inf cases where clean replies nil.

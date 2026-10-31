repro.py calls (1).__round__(None) directly. Clean returns 1; buggy raises TypeError (None isn't an index).

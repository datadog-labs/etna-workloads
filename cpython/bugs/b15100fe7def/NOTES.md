repro.py configures logging via fileConfig and prints the root handler's name: 'hand1' on clean, None on buggy (injection removes h.name = hand in logging.config._install_handlers).

Compiles a generic fn with an unnormalizable projection field; SROA on the injected compiler leaves free regions in MIR, causing an ICE (broken MIR validation) instead of building and running.

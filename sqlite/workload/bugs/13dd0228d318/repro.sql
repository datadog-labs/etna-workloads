.parameter set ?1 'A'
.parameter set ?2 'B'
.parameter set ?3 'C'
.parameter set ?4 'D'
.trace stdout --expanded
SELECT ?1 || ?1 || ?2 || ?3 || ?4 || ? || ?1 || ?;

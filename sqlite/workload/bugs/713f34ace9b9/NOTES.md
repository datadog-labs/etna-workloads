A view and a trigger whose WITH-clause CTE references an attached database (aux.t2) or a bound parameter.
Clean shell rejects both ("view v2 cannot reference objects in database aux", "trigger cannot use variables").
The buggy shell skips walking CTE selects, so the statements are wrongly accepted.

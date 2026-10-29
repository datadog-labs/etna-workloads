SELECT '{x: -.5}'->>'x', json('{x: -.5}');
SELECT '{x: +.5}'->>'x', json('{x: +.5}');
SELECT '{x: -.5e-1}'->>'x', json('{x: -.5e-1}');
SELECT '{x: +.5e-2}'->>'x', json('{x: +.5e-2}');

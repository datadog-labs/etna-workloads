SELECT ts_headline('english', 'foo barbar', to_tsquery('english', 'foo'),
  'StartSel=' || repeat('x', 32768));
SELECT ts_headline('english', 'foo barbar', to_tsquery('english', 'foo'),
  'StopSel=' || repeat('x', 32768));
SELECT ts_headline('english', 'foo barbar', to_tsquery('english', 'foo'),
  'FragmentDelimiter=' || repeat('x', 32768));

for (const f of ['atob', 'btoa']) {
  try { const r = globalThis[f](); console.log(f, 'returned', r); }
  catch (e) { console.log(f, 'threw', e.code, e.name); }
}

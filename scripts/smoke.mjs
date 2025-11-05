/*
  Minimal smoke test for the MLM API.
  Usage:
    node scripts/smoke.mjs https://mlm-database.onrender.com
*/
const base = process.argv[2] || process.env.BASE_URL || 'http://localhost:5000';

async function json(path, opts = {}) {
  const res = await fetch(base + path, {
    ...opts,
    headers: { 'Content-Type': 'application/json', Accept: 'application/json', ...(opts.headers || {}) },
  });
  const text = await res.text();
  try { return { status: res.status, body: text ? JSON.parse(text) : {} }; } catch { return { status: res.status, body: { raw: text } }; }
}

function ok(name, cond, extra = '') {
  if (cond) console.log(`✔ ${name}`);
  else {
    console.error(`✘ ${name} ${extra}`);
    process.exitCode = 1;
  }
}

(async () => {
  const health = await json('/health');
  ok('health', health.status === 200 && health.body?.status === 'ok', JSON.stringify(health.body));

  // Public endpoints sanity
  const corsProbe = await fetch(base + '/auth/login', { method: 'OPTIONS' });
  ok('cors OPTIONS', corsProbe.status === 200 || corsProbe.status === 204, `status=${corsProbe.status}`);

  console.log('Done.');
})();


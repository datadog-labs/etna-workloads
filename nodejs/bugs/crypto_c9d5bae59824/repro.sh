d=$(mktemp -d); cd "$d"; cat > r.js <<'EOF'
const { internalBinding } = require('internal/test/binding');
const { Argon2Job, kCryptoJobSync, kTypeArgon2id } = internalBinding('crypto');
const e = Buffer.alloc(0);
try {
  const job = new Argon2Job(kCryptoJobSync, Buffer.from('password'), Buffer.alloc(16, 2),
                            0, 32, 16, 1, e, e, kTypeArgon2id);
  const [err, res] = job.run();
  console.log('run:', err && err.message, err && err.code, res);
} catch (err) {
  console.log('ctor threw:', err.message, err.code);
}
EOF
"$1" --expose-internals --no-warnings r.js

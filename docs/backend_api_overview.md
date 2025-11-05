Backend API Overview (from code)
================================

Base URL
- Production: https://mlm-database.onrender.com

Auth
- POST /auth/signup
  - body: { username, phone, email?, password?, referralCode? }
  - 201 → { ok, next: 'verify_phone', user }
- POST /auth/request-otp
  - body: { type: 'EMAIL'|'PHONE', identifier }
  - 200 → { ok, expiresAt }
- POST /auth/verify-otp
  - body: { type, identifier, code, referralCode? }
  - 200 → { ok, user, token }
- POST /auth/verify-phone-otp
  - body: { phone, code }
  - 200 → { ok, next: 'set_transaction_pin', token }
- POST /auth/set-pin (auth)
  - body: { pin: 'dddd' }
  - 200 → { ok }
- POST /auth/login
  - body: { identifier, password? | code? }
  - 200 → { ok, user, token }
- POST /auth/login/request-otp
  - body: { identifier }
  - 200 → { ok }
- POST /auth/forgot-password/request-otp
  - body: { identifier }
  - 200 → { ok }
- POST /auth/forgot-password/reset
  - body: { type: 'EMAIL'|'PHONE', identifier, code, newPassword }
  - 200 → { ok }
- POST /auth/forgot-pin/request-otp
  - body: { identifier }
  - 200 → { ok }
- POST /auth/forgot-pin/reset
  - body: { identifier, code, newPin }
  - 200 → { ok }
- POST /auth/logout
  - 200 → { ok }

Wallet (auth)
- GET /wallet → { ok, wallet }
- POST /wallet/transfer → { ok, wallet }
  - body: { amount, pin }
- GET /wallet/transactions → { ok, items, nextCursor }
  - query: limit?, cursor?

Payments (auth)
- POST /payments/add-funds/order → { ok, order }
  - body: { amount, currency? }
- GET /payments/plans → { ok, plans }
- POST /payments/token/purchase → { ok, order, purchase }
  - body: { planId }
- GET /payments/token/purchases → { ok, items }
- GET /payments/token/purchases/:id/invoice → PDF bytes
- POST /payments/withdraw → { ok, transaction, wallet?, requiresApproval? }
  - body: { amount, method: 'UPI'|'BANK', details: {...}, pin }
- GET /payments/transactions → { ok, items }
- POST /payments/withdrawals/:id/approve (admin) → { ok }
- POST /payments/withdrawals/:id/reject (admin) → { ok }

Webhooks
- POST /webhooks/razorpay
- POST /webhooks/stripe

Notifications (auth)
- GET /api/notifications → { ok, items, nextCursor }
  - query: limit?, cursor?, unread=true?
- POST /api/notifications/read → { ok, count }
  - body: { ids: string[] }
- DELETE /api/notifications/:id → { ok }
- POST /api/admin/notifications/broadcast (admin) → { ok, count }
  - body: { title, message, type? }

MLM (auth)
- GET /mlm/tree → { ok, root, nodes, pagination }
  - query: depth?, userId?
- GET /mlm/downline → { ok, members, pagination }
  - query: depth?, userId?, mode=all|direct
- GET /mlm/commissions → { ok, items, summary }
  - query: level?, limit?, from?, to?

Admin (auth + admin)
- POST /admin/clear-db → { ok }

Auth Mechanics
- Authorization via cookie `access_token` (set by server) or `Authorization: Bearer <token>` header.
- CSRF optional (disabled by default unless CSRF_PROTECTION=true).

Health
- GET /health → { status: 'ok', name, env }

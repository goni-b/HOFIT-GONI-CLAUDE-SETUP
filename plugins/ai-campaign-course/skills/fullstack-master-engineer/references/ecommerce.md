# E-Commerce & Payments

Use in COMMERCE mode to build a store or add payments. The money path must be correct and tamper-proof —
server-verified prices, webhook-confirmed payments, idempotent orders.

## The commerce chain
catalog → product page → cart → checkout → **payment** → order created → confirmation → fulfillment.
Each step persists; the order is only real once the payment provider confirms it.

## Non-negotiable money rules
- **Never trust client-sent prices or totals.** Recompute the price and total on the server from the catalog
  at checkout time. A client that posts `price: 0` must not get a free order.
- **Confirm payment via webhook, not the browser redirect.** The redirect can be skipped/faked; the
  provider's signed webhook is the source of truth for "paid." Verify the signature, then mark the order paid.
- **Idempotent order creation.** Use an idempotency key / dedupe by provider event ID so a retried webhook or
  double-click never creates two orders or two charges.
- **Server-side everything sensitive** — secret keys, price calculation, inventory decrement, discount
  validation all live on the server.
- **Validate discounts/coupons server-side** — check existence, validity window, usage limits, and
  applicability; never apply a client-claimed discount blindly.
- **Decrement inventory atomically** at payment confirmation; prevent overselling with a transaction/lock.

## Providers
- **Stripe** (global) — Checkout Session or Payment Intents; the secret key is server-only; handle webhooks
  (`checkout.session.completed`, `payment_intent.succeeded`) with signature verification; use idempotency
  keys; test in test mode before live.
- **Payplus** (Israeli, the owner's processor) — generate a payment page/link server-side, redirect the
  customer, and confirm via Payplus's callback/IPN with verification before fulfilling. Account for the
  owner's Payplus structures (e.g. split/clearing arrangements) and reconcile against what's actually
  cleared. VAT (מע"מ) must be handled correctly on prices and invoices.
- **Shopify** — when on Shopify: Liquid for storefront, Storefront/Admin APIs for custom logic, checkout
  extensions; respect Shopify's checkout (don't reinvent it); use webhooks for orders/fulfillment.

## Cart & checkout UX
- Persist the cart (server for logged-in users; durable client storage otherwise) so it survives refresh.
- Show price breakdown clearly (subtotal, shipping, VAT, total) before payment.
- Minimize checkout fields; offer guest checkout; show trust/security badges near the pay button.
- Handle every payment outcome: success, failure, pending, cancelled, and provider timeout — with clear UI
  and a recoverable state.

## Orders & post-purchase
- Create the order in a clear state machine: pending → paid → fulfilled → (refunded/cancelled).
- Send confirmation only after payment is verified.
- Generate a proper invoice/receipt (with VAT where required); store it.
- Build refunds/cancellations through the provider's API and reflect them in the order state.

## For Israeli stores
Hebrew + RTL storefront (`hebrew-rtl.md`); prices and invoices VAT-correct; phone/email inputs `dir="ltr"`;
Payplus as the default processor; clear, plain-Hebrew product and checkout copy.

## Never
- Use a client-supplied price/total to charge or to create an order.
- Fulfill on the browser redirect instead of the verified webhook/callback.
- Create orders/charges without idempotency.
- Put a payment secret key in client code.
- Apply discounts or decrement inventory without server-side validation and atomicity.

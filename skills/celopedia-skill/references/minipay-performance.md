# MiniPay Performance — Measure & Optimize Load Speed

> Docs: https://docs.minipay.xyz/getting-started/best-practices.html (Performance) · https://pagespeed.web.dev · https://web.dev/articles/vitals · https://posthog.com/docs/web-analytics/web-vitals
>
> **Companion files:** `minipay-requirements.md` §4 (the listing requirement) · `growth-analytics.md` §6 (PostHog setup) · `defi-protocols.md` (the wallet SDKs whose weight this file helps you defer).

## Why this matters (it's an entry barrier, not a nice-to-have)

MiniPay users open Mini Apps **inside a webview, on mid-range Android phones, on mobile data in emerging markets**. A heavy first load is a hard filter: every extra second of load time drops a measurable share of first-time users before they ever see your app. MiniPay makes this explicit — a **PageSpeed Insights mobile score of 90+** is part of the submission, and low scores block listing (`minipay-requirements.md` §4).

Treat load speed as a feature you ship and then **monitor continuously with real-user data**, not a one-time lab check.

---

## 1. Measure in two layers

Lab and field measure different things — you need both.

### Lab (controlled, for diagnosis)

- **PageSpeed Insights** (`https://pagespeed.web.dev`, strategy: mobile) or **Lighthouse** in Chrome DevTools with throttling set to *Slow 4G* + *4× CPU*. This is the number MiniPay asks for, and it tells you exactly which asset is heavy.
- Always test against a **mid-range device profile** (e.g. "Moto G Power" in DevTools), not your dev laptop. The lab number on a fast machine lies.

### Field / RUM (real users — what actually matters for MiniPay)

Lab is an idealized single run. **Real-user monitoring (RUM)** tells you what your actual MiniPay audience experiences on their phones and networks. PostHog gives you this for free and you very likely already have it installed for analytics (`growth-analytics.md`).

**Enable Web Vitals capture** — this is off by default. Add `capture_performance` to your `posthog.init`:

```js
posthog.init('phc_YOUR_PROJECT_KEY', {
  api_host: 'https://us.i.posthog.com',
  person_profiles: 'always',
  autocapture: true,
  capture_performance: { web_vitals: true },   // ← emits one $web_vitals event per pageview
});
```

PostHog then emits a `$web_vitals` event per pageview with `$web_vitals_LCP_value`, `$web_vitals_INP_value`, `$web_vitals_CLS_value`, `$web_vitals_FCP_value` (LCP/INP/FCP in ms, CLS unitless).

### Read the p75 (Google's grading percentile) server-side

Core Web Vitals are graded at the **75th percentile** of real users — not the average — so the number reflects the experience of most users *including* the slower ones. Query it with HogQL (keep your PostHog API key server-side; see `growth-analytics.md`):

```sql
SELECT
  quantile(0.75)(toFloat(properties.$web_vitals_LCP_value)) AS lcp_p75,
  quantile(0.75)(toFloat(properties.$web_vitals_INP_value)) AS inp_p75,
  quantile(0.75)(toFloat(properties.$web_vitals_CLS_value)) AS cls_p75,
  quantile(0.75)(toFloat(properties.$web_vitals_FCP_value)) AS fcp_p75,
  count() AS samples
FROM events
WHERE event = '$web_vitals' AND timestamp >= now() - interval 1 day
```

**Window tip:** a **24h** window surfaces the impact of an optimization within a day; a 7-day window is more stable but lags — after you ship a fix it keeps averaging in days of old, slow traffic. Use a short window to confirm a change landed, a longer one for a stable baseline. With few samples (e.g. < ~30) the p75 is noisy — don't over-read a single day.

### Core Web Vitals thresholds (p75)

| Metric | Good | Needs improvement | Poor |
|--------|------|-------------------|------|
| **LCP** (Largest Contentful Paint) | ≤ 2.5 s | ≤ 4.0 s | > 4.0 s |
| **INP** (Interaction to Next Paint) | ≤ 200 ms | ≤ 500 ms | > 500 ms |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | ≤ 0.25 | > 0.25 |
| **FCP** (First Contentful Paint) | ≤ 1.8 s | ≤ 3.0 s | > 3.0 s |

Surface these on your `/stats` page (which MiniPay wants anyway, `minipay-requirements.md` §8) so reviewers — and you — can see load speed at a glance and watch it after each deploy.

---

## 2. Optimize — the playbook (ordered by typical impact)

These are the levers that most often move LCP/FCP for a MiniPay-style stack (static or SPA front end + a wallet/RPC layer). Verify each against your own RUM after shipping.

### 🥇 Fix font loading — never `@import`

Loading a web font with `@import url(...)` **inside your CSS** is one of the most common silent killers. It chains the requests: HTML → download CSS → *then* discover the `@import` → download the font CSS → download the font files. All serial, all blocking first paint.

```css
/* ❌ in styles.css — chained, blocks render */
@import url('https://fonts.googleapis.com/css2?family=YourFont&display=swap');
```

```html
<!-- ✅ in <head> — parallel with your stylesheet, preconnect warms the font host -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=YourFont&display=swap">
```

Always keep `&display=swap` so text renders immediately in a fallback font and swaps when the web font arrives. For the absolute fastest path, **self-host** the font files and `preload` the one weight you use above the fold. Even better for a webview: prefer a **system font stack** and skip web fonts entirely.

### 🥈 Lazy-load the wallet SDK (huge MiniPay win)

Wallet connection libraries (WalletConnect / Reown AppKit / wagmi and their connectors) are typically the **heaviest dependency in the bundle** — often hundreds of KB and dozens-to-hundreds of modules. **MiniPay injects `window.ethereum` and connects without any of them**, so for your primary audience this code is pure dead weight on first load.

Don't import the wallet modal at module top level. Load it **on demand**, the first time a non-MiniPay user clicks "Connect":

```js
// Keep ethers/viem eager if you need it for read-only data on first paint.
// Load the wallet modal stack only when actually needed.
let _modal;
async function ensureWalletModal() {
  if (_modal) return _modal;
  const { createAppKit } = await import('@reown/appkit');   // dynamic import → its own chunk
  // ...create + configure the modal here, wire account subscription...
  return (_modal = createAppKit(/* ... */));
}

connectButton.addEventListener('click', async () => {
  const modal = await ensureWalletModal();   // first click pays the one-time cost
  modal.open();
});
```

Detect MiniPay early and skip the modal path entirely for those users:

```js
const inMiniPay = typeof window !== 'undefined' && window.ethereum?.isMiniPay;
```

Tradeoff: a returning desktop user with a persisted session reconnects on first click instead of automatically on load — acceptable for the bundle savings, and MiniPay users are unaffected.

### 🥉 Defer non-critical scripts off the critical path

Anything not needed for first paint should not block it: analytics, websocket clients, chat widgets, third-party SDKs.

- Add `defer` to classic scripts; `type="module"` defers automatically.
- Keep **dependency order**: deferred scripts execute in document order after parsing, so place a script that *defines* globals before the scripts that *consume* them.
- Don't defer a script another inline script needs synchronously during parse — verify order after changing it.

### Reserve space for late content (kills CLS)

Layout shift comes from elements that appear *after* first paint and push content down. Two frequent culprits:

- **Images without dimensions** — always set `width`/`height` attributes (or CSS `aspect-ratio`) so the browser reserves the box before the image loads.
- **Headers/banners injected by JS** (a deferred script that mounts a nav) — give the placeholder a `min-height` equal to the final element so nothing jumps when it mounts.

```html
<img src="logo.webp" alt="Logo" width="168" height="168">
<div id="app-header" style="min-height:64px"></div> <!-- reserved before JS injects the header -->
```

### Prioritize the LCP element

Identify your Largest Contentful Paint element (usually the hero image or a large heading) in the Lighthouse report, then:

```html
<link rel="preload" as="image" href="hero.webp" fetchpriority="high">
<!-- and on the element itself -->
<img src="hero.webp" width="320" height="320" fetchpriority="high" alt="...">
```

### Preconnect to the origins you hit early

Open the TCP+TLS handshake in parallel with parsing for the hosts you call on load — your RPC endpoint, your API, CDNs:

```html
<link rel="preconnect" href="https://forno.celo.org">
<link rel="preconnect" href="https://your-cdn.example" crossorigin>
```

### Asset & bundle hygiene

- Images in **WebP/AVIF or SVG**, never oversized PNG/JPG (`minipay-requirements.md` §4).
- Split large i18n/translation blobs and heavy libs into separate chunks; load only what the current view needs.
- Lazy-load below-the-fold images (`loading="lazy"`) and virtualize long lists.

---

## 3. Targets & verification

- **PageSpeed Insights mobile ≥ 90** (the listing requirement). Re-run after each optimization.
- **Core Web Vitals p75 all green**: LCP ≤ 2.5s, INP ≤ 200ms, CLS ≤ 0.1, FCP ≤ 1.8s.
- Confirm wins with **field data** (PostHog p75), not just lab — the lab can pass while real users on slow networks still struggle.
- Re-test on a **real mid-range Android inside MiniPay** (use ngrok + MiniPay's "Test Page", see `minipay-guide.md`), not just desktop Chrome.

**Don't silently ship a regression:** a heavy dependency added later (a new chart lib, a wallet connector imported at top level again) can quietly undo these gains. Keep the Web Vitals card on your `/stats` page and watch it after each release.

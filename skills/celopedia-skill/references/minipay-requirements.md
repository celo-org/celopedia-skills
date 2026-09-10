# MiniPay Submission Requirements

> **Single source of truth:** https://docs.minipay.xyz/ — specifically https://docs.minipay.xyz/getting-started/submit-your-miniapp.html
> - Additional source: Opera MiniPay "Build for MiniPay: Developer Requirements" (official PDF)
>
> Last updated: 2026-09-10.

Getting a Mini App listed in MiniPay is a **two-stage process**:

1. **Intake form** — submit basic app info at `https://minipay.to/mini-apps` (the official submission docs page links the same form as `https://developer.minipay.to/mini-app-listing` — both resolve). If the app looks promising, the MiniPay team books a first call with you.
2. **Readiness form** — after the first call, MiniPay sends a full readiness form. The checklist in Stage 2 below is what they will assess against.

For how to build each piece, see `minipay-guide.md`, `minipay-templates.md`, and `minipay-scaffold-from-scratch.md`. For the full canonical docs index, see `minipay-docs-map.md`.

---

## Stage 1 — MiniPay Intake Form

Submit at: **`https://minipay.to/mini-apps`**

### ⚠️ Do not submit a half-built app

> If your app is not ready, **do not submit yet**. The MiniPay team triages on quality — if the submission is rough, they will **deprioritize follow-up communication**. You typically only get one good first impression, so wait until the app is in good shape before applying.

### What the intake form asks

| Field | Required | Notes |
|------|------|------|
| Developer / Company Name | ✅ | Who's building this app |
| Email | ✅ | Contact email for follow-up |
| App URL | ✅ | Link to your live app or demo |
| Category | ✅ | DeFi · Social & Communities · Payments · Gaming · Content/News · Digital Collectibles · Other |
| Short Description | ✅ | One sentence — what does your app do? |
| Does your App already support MiniPay? | ✅ | Yes / No |
| App Screenshots | ✅ | PNG or JPG, max **500 KB** each, at least **3** high-quality screenshots showing the app in action |
| Smart Contract Address | optional | If applicable |
| Is the smart contract audited? | ✅ | Yes / No |
| Do you have social media? | ✅ | Yes / No |

### Recommended to have ready *before* you submit

These are a subset of the full Stage 2 checklist, but they are the items most visible from a quick review of your app and links. If they're not in place, the intake reviewer will likely bounce you. Get these right first:

**From "Seamless User Experience":**

- [ ] **Zero-click connect** — no "Connect Wallet" button when `window.ethereum.isMiniPay === true`
- [ ] **No `personal_sign` / `eth_signTypedData`** anywhere in the app
- [ ] **No wallet addresses displayed, copyable, or shareable** anywhere in the app
- [ ] **No free-text "withdraw to address" field** — withdrawals to arbitrary external addresses are prohibited
- [ ] **USDT is supported** — mandatory for every Mini App
- [ ] **Pre-flight balance check** — balance is verified against amount **+ network fee** before any transaction is triggered

**From "User-Facing Copy" (strict):**

- [ ] UI copy uses: **Network fee**, **Deposit**, **Withdraw**, **Stablecoin** — **not** gas / onramp / offramp / crypto

**From "Smart Contract Standards":**

- [ ] All contracts **verified on Celoscan**
- [ ] Sample **transaction hashes** collected for every user-facing method

**Other quick-look items:**

- [ ] Tested at **360 × 640** mobile resolution
- [ ] Images are **SVG or WebP**
- [ ] **PageSpeed Insights** score captured for production URL
- [ ] Redirects to the **Deposit deeplink** on insufficient balance (`https://link.minipay.xyz/add_cash`)
- [ ] Every on-chain action has explicit **pending / success / failure** UI states
- [ ] **App name + logo** visible and clearly distinct from MiniPay's own branding

If those are solid, submit the intake form. If they're not, build first, then come back.

---

## Stage 2 — Post-call Readiness Checklist

Everything below is what MiniPay assesses against in the readiness form **after your first call**. You don't need to submit this checklist with the intake form, but you'll need to satisfy all of it before listing.

### 1. Seamless User Experience

> Docs: https://docs.minipay.xyz/getting-started/wallet-connection.html · https://docs.minipay.xyz/getting-started/best-practices.html

- **Zero-Click Connect** — do **not** show a "Connect Wallet" button inside MiniPay. Auto-retrieve the wallet address from `window.ethereum`. Pattern: `minipay-templates.md` §1; detection: `minipay-guide.md` → MiniPay Detection; docs: https://docs.minipay.xyz/getting-started/wallet-connection.html.
- **No Message Signing** — do **not** prompt users to `personal_sign` or `eth_signTypedData` to access or authenticate. MiniPay does not support these methods. See `minipay-guide.md` → Important Constraints #4 and the wallet-connection doc above.
- **No Address Exposure** — do **not display, copy, or share the user's wallet address anywhere in the app**. This is stricter than "don't use it as the primary identifier": no address text, no copy-to-clipboard button, no share sheet, no QR of the address, and a **truncated `0x1234…abcd` form is not an escape hatch**. Use the phone number (resolved via ODIS → FederatedAttestations) or an app-specific alias as the user-visible identity. Lookup flow: `odis-socialconnect.md` and `minipay-guide.md` → Phone Number → Address Resolution; docs: https://docs.minipay.xyz/technical-references/phone-number-lookup.html.
- **No Arbitrary Withdrawals** — apps are **prohibited from allowing withdrawals to arbitrary or external wallet addresses**. No free-text address input, no paste-an-address flow, no "send to any wallet" option. Payouts must go to a destination the app already controls or that MiniPay resolves for you (the connected user, or a phone number resolved via ODIS). If your product genuinely needs an off-platform payout, route it through the MiniPay withdrawal surfaces instead of building your own.
- **Transaction Feedback** — every on-chain action needs explicit pending / success / failure states. Full rule: §9 below.

### 2. Currency & Stablecoin Logic

> Docs: https://docs.minipay.xyz/technical-references/retrieve-balance.html · https://docs.minipay.xyz/technical-references/gas-estimation.html · https://docs.minipay.xyz/faq.html (Q9, Q11)

- **USDT Is Mandatory** — every Mini App **must support USDT natively**. It is not one option among several; an app that cannot transact in USDT is not listable.
- **Token Support** — supported tokens are **USDT, USDC, and USDm only**, and **USDT must be among them**. **Do not add support for any token MiniPay does not natively support** — arbitrary ERC-20s, LP tokens, and wrapped assets do not belong in a Mini App's UI. **Never display or require the CELO token**; MiniPay handles fees automatically via CIP-64 fee abstraction. See `faq.html` Q11.
- **Dynamic Adaptation** — adapt to the user's **preferred stablecoin** (the one they hold the most of). Working helper: `minipay-templates.md` §6 — Preferred Stablecoin Selection. Balance lookup: https://docs.minipay.xyz/technical-references/retrieve-balance.html.
- **Graceful Degradation** — if your app only supports one stablecoin, show a clear explainer ("This app accepts USDC only. Swap in MiniPay first.") instead of a broken interface.
- **Pre-Flight Balance Check** — **before triggering any transaction**, programmatically verify that the user's balance in the relevant stablecoin covers **the transaction amount *plus* the estimated network fee**. Checking the amount alone is the common failure: the transfer is affordable, the fee is not, and the transaction reverts in the user's face. On a shortfall, show a calm explanatory message (not a raw error) and redirect to the Add Cash deeplink — see §6 _Low-Balance Handling_. Working pattern with fee estimation: `minipay-templates.md` §7 — Pre-Flight Check & Transaction Status.

### 3. User-Facing Copy (strict)

> Docs: https://docs.minipay.xyz/getting-started/submit-your-miniapp.html · https://docs.minipay.xyz/getting-started/best-practices.html (Transaction UX)

Replace crypto-jargon with user-friendly terms everywhere a real user sees them (buttons, tooltips, error messages, copy):

| ❌ Don't say | ✅ Say |
|------|------|
| Gas / Gas fee | **Network fee** |
| Onramp / Buy (crypto) | **Deposit** |
| Offramp / Sell (crypto) | **Withdraw** |
| Crypto / Crypto token | **Stablecoin** or **Digital dollar** |
| Wallet address (as primary identifier) | Phone number |

**Scope:** all UI strings, button labels, tooltips, error messages. Code identifiers and RPC method names (`gasEstimate`, `eth_gasPrice`, `feeCurrency`) are technical — keep those as-is.

### 4. Technical Performance & Optimization

> Docs: https://docs.minipay.xyz/getting-started/submit-your-miniapp.html · https://docs.minipay.xyz/getting-started/best-practices.html (Performance, User Experience) · https://docs.minipay.xyz/getting-started/deployment.html

- **Mobile-First Resolution** — the UI must be responsive and fully functional at **360w × 640h**. This is the hard minimum from the readiness PDF, and the smaller of the two figures floating in MiniPay's public material — design and verify against 360 × 640. Use Chrome DevTools device mode to validate before submission.
- **Asset Optimization** — use **SVG or WebP** for images. Avoid PNG/JPG for anything larger than a few KB.
- **Performance Benchmarking** — submit a **PageSpeed Insights** score (`https://pagespeed.web.dev`) for your production URL with the form. Aim for 90+ on mobile. Low scores block listing. **For how to measure real-user load speed (Web Vitals via PostHog) and the optimization playbook to actually hit 90+, see `minipay-performance.md`.**
- **Network Transparency** — provide a full manifest of every **URL, subdomain, and origin** your app calls (JS, CSS, fonts, RPCs, APIs). MiniPay reviews this for supply-chain risk. Keep this manifest accurate after listing — see §10.
- **Streamlined First Version** — the initial release should do **one thing well**. Ship the core flow only; leave secondary features for a later version. Long multi-step flows are the most common source of both user friction and review failures, and every extra screen is another place the app can break on a slow connection. If your product is complex, cut it down before you submit rather than after.

### 5. Smart Contract Standards

> Docs: https://docs.minipay.xyz/getting-started/smart-contracts.html

- **Public Verification** — all your contract source code must be **verified on Celoscan** (`https://celoscan.io`) so users can inspect it. How-to: `builder-guide.md` → Verification.
- **Transaction Samples** — for every user-facing method your app uses, provide a **sample transaction link on Celoscan** with the submission.

### 6. Integration & Support

> Docs: https://docs.minipay.xyz/technical-references/deeplinks.html · https://docs.minipay.xyz/getting-started/best-practices.html (Error Handling)

- **Code Guidelines** — use the patterns in this skill (`minipay-guide.md`, `minipay-templates.md`). They mirror the canonical MiniPay Developer Documentation at https://docs.minipay.xyz/.
- **Low-Balance Handling** — when a user cannot complete an action because their balance is too low, **redirect to the MiniPay Add Cash deeplink** rather than showing an error. Deeplink: `https://link.minipay.xyz/add_cash` (optionally `?tokens=USDm,USDC,USDT`). Canonical deeplink list: https://docs.minipay.xyz/technical-references/deeplinks.html — fetch before shipping; new deeplinks are added periodically.
- **Dedicated Support** — provide an **in-app support link** reachable from inside the Mini App (header icon, footer, or settings). Accepted channels: Telegram, WhatsApp, email, or web support portal.
- **SLA** — you must fix reported **critical issues within 24 hours**, or MiniPay will temporarily disable your listing.

#### Recommended: AI support agent on Telegram

Meeting the 24h SLA across a growing user base is hard with manual triage. A recommended pattern is to **front Telegram support with an AI agent** that:

- **Intakes** the user message, opens a ticket, and replies with an acknowledgement + ticket ID
- **Categorises** each ticket by **type** (bug · UX · payment failure · account / KYC · feature request) and **criticality** (P0 funds-at-risk · P1 blocking · P2 degraded · P3 question) so P0/P1 surface immediately for the 24h SLA
- **Prepares a draft resolution** from app logs, prior tickets, on-chain transaction state, and the FAQ — so a human dev only has to **review, approve, and send** (or override)
- **Tracks status** (open · awaiting-user · awaiting-dev · resolved) and chases stale tickets

You stay in the loop as the human approver, but the agent handles intake, classification, and first-draft answers — which is what makes the 24h critical-fix SLA actually achievable.

### 7. Branding & Legal

> Docs: https://docs.minipay.xyz/getting-started/submit-your-miniapp.html (Legal and Branding)

- **Clear Ownership** — display your app's **name and logo** prominently. It must be obvious to the user that the service is operated by your entity, not by MiniPay.
- **Developer Identity & Disclaimer** — clearly display the official **developer name or organisation**, and **state explicitly that the app is operated by that developer and not by Opera or MiniPay**. A line in the About screen or footer is enough — e.g. "Operated by <Your Company>. Not affiliated with Opera or MiniPay." An implicit logo is not sufficient; the disclaimer has to be readable.
- **Essential Sections** — the following must all exist and be reachable from the **footer or menu**:
  - **Privacy Policy**
  - **Terms & Conditions**
  - **Support / Contact info**
  - **About** — who built this and what it does
  - **How to Use** — a short guide to the core flow
  The last two are frequently missed. MiniPay's users are largely first-time app users in emerging markets; an app with no "How to Use" screen generates support load that lands on your 24h SLA.

### 8. Analytics & Operational Visibility

MiniPay reviewers want to see that you actually know how your app is performing. Stand up a **public-or-shared stats / analytics page** for the Mini App that surfaces, at a minimum:

**Usage metrics** (from your web analytics — Plausible, PostHog, Umami, GA4, etc.):

- **DAU** — daily active users
- **MAU** — monthly active users
- **Retention** — D1 / D7 / D30 cohort retention (so growth isn't just acquisition)
- **Top countries** — useful given MiniPay's per-country availability

**On-chain metrics** (from your contracts on Celo — index via The Graph, Goldsky, Dune, or a lightweight indexer on top of Blockscout / Celoscan APIs):

- **Transactions per day / week / month / lifetime** broken down by contract method
- **Unique on-chain users** per period (distinct `tx.from`)
- **Volume** transacted per stablecoin (USDT / USDC / USDm), per period
- **Network fees paid** by users (sum of `gasUsed × effectiveGasPrice`, converted to USD)
- **Protocol fees / revenue** collected by your contracts (if your contract charges a fee — emit a `FeeCollected` event and sum it)
- **Failed-tx rate** — share of transactions that revert (proxy for UX or contract bugs)

**Why this matters for listing:** these numbers are what MiniPay uses to decide promotion, featuring, and continued listing. They also surface UX regressions (e.g. failed-tx spikes) before users complain.

Where to publish: a `/stats` page inside the Mini App (read-only, no wallet required) or a Dune dashboard linked from your app footer. Either works — the requirement is that the numbers are **fresh and reachable**.

### 9. Transaction Feedback

> Docs: https://docs.minipay.xyz/getting-started/best-practices.html (Transaction UX, Error Handling)

Every on-chain action must give the user immediate, descriptive state. Three states, all mandatory:

| State | Requirement |
|---|---|
| **Pending** | Show a clear loading indicator the moment the user signs — never a dead button or a frozen screen. Cover both phases: submitting, then waiting for confirmation. |
| **Success** | Update the UI **on on-chain confirmation**, not on submission. Optionally deep-link to the receipt (`https://link.minipay.xyz/receipt?tx=<hash>`). |
| **Failure** | Show a descriptive, user-friendly message for rejected or failed transactions. "Transaction failed" is not descriptive; "You cancelled the payment" and "Not enough USDT to cover the amount and network fee" are. |

**Branch on error codes and standard error names, not on message text.** Provider and RPC message strings change between versions and locales; codes do not. Map codes to copy once, in one place. Implementation: `minipay-templates.md` §7.

### 10. Whitelisting Integrity

> Docs: https://docs.minipay.xyz/getting-started/submit-your-miniapp.html

Once your Mini App is approved, MiniPay whitelists the exact **contract addresses, method signatures, parameters, and URLs** you submitted. That allowlist is enforced at transaction time.

**The rule: what you submit for whitelisting must not change afterwards.**

Changes that break a listed app — often silently, and often only in production:

- **Adding or reordering a parameter** on a whitelisted method (the selector changes; the call is rejected before it is ever broadcast)
- **Deploying a new contract address** — including a routine redeploy or a proxy swap
- **Moving to a new URL, subdomain, or origin** — including a new CDN host or analytics endpoint not in your submitted manifest

The symptom is a permission/rejection error from the wallet on a build that works fine outside MiniPay, which makes it easy to misdiagnose as a code bug.

**What to do:**

- **Submit the production-ready build**, not a staging or in-progress version. Freeze the ABI and the URL set before you submit.
- If a contract or signature change is unavoidable, treat it as **requiring re-whitelisting** — coordinate with MiniPay *before* shipping, not after users report failures.
- Keep the URL/origin manifest from §4 as a living document, and re-submit it whenever it changes.

### 11. Dependency Security

> Docs: https://docs.minipay.xyz/getting-started/submit-your-miniapp.html (Dependency security)

A Mini App handles user funds inside a wallet, so its supply chain is in scope for review:

- **Pin exact npm versions** — no `^` or `~` ranges in `package.json`
- **Enforce a minimum age** of 7+ days before adopting a new package version
- **Set `ignore-scripts=true`** in `.npmrc` so install-time scripts cannot run
- **Commit the lockfile** and use frozen installs in CI (`npm ci` / `pnpm install --frozen-lockfile`)

(`agent-security.md` is a *different* layer — prompt injection and key handling for LLM-backed agents. It does not cover npm supply chain; read it only if your Mini App ships an agent or chatbot.)

---

## Deeplinks (MiniPay)

> Canonical list: https://docs.minipay.xyz/technical-references/deeplinks.html — fetch this before shipping; MiniPay publishes new deeplinks periodically. Full mirror in `minipay-docs-map.md` → _Deeplinks_.

| Deeplink | URL | When to use |
|----------|-----|-------------|
| Add Cash | `https://link.minipay.xyz/add_cash` (optionally `?tokens=USDm,USDC,USDT`) | Low balance; user needs to top up |
| Open Mini App | `https://link.minipay.xyz/browse?url=xxx` | Deep-link into an approved Mini App |
| MiniApps tab | `https://link.minipay.xyz/discover` | Jump to the discovery tab |
| Transaction receipt | `https://link.minipay.xyz/receipt?tx=xxx[&celebrate]` | Show a receipt screen for a tx hash |
| User's QR code | `https://link.minipay.xyz/qr` | Open the user's own QR screen |
| Invite friends | `https://link.minipay.xyz/invite_friends` | Trigger the invite flow |
| Pockets / balance | `https://link.minipay.xyz/balance` | Open the user's Pockets screen |

> **Opening your app from an external link:** use the **Browse** deeplink
> `https://link.minipay.xyz/browse?url=<url-encoded target>` — the target short
> link (e.g. `https://opr.as/xxxx`) is **provisioned by MiniPay; request it**.
> MiniPay does **not** do referrals or dynamic links — carry your own params
> (`?ref=`) in the target URL. See `minipay-guide.md` → Deeplinks + Sharing.

---

## Full pre-listing checklist (Stage 2)

Copy this block into your submission PR or internal review doc:

- [ ] Zero-click connect (no Connect Wallet button when `window.ethereum.isMiniPay === true`)
- [ ] No `personal_sign` / `eth_signTypedData` anywhere in the app
- [ ] No wallet addresses displayed, copyable, or shareable anywhere (truncated forms included)
- [ ] No free-text / arbitrary-address withdrawal flow
- [ ] **USDT supported** (mandatory), plus USDC / USDm as applicable — no CELO, no non-native tokens
- [ ] Picks the user's highest-balance stablecoin, or explains single-token UX clearly
- [ ] Pre-flight check verifies balance covers **amount + network fee** before every transaction
- [ ] Every on-chain action has pending / success / failure states, with errors mapped from **codes**, not message text
- [ ] First version is scoped to the core flow only
- [ ] UI copy uses: **Network fee**, **Deposit**, **Withdraw**, **Stablecoin** (not gas / onramp / offramp / crypto)
- [ ] Tested at **360 × 640** mobile resolution
- [ ] Images are SVG or WebP
- [ ] PageSpeed Insights score captured for production URL
- [ ] URL / subdomain / origin manifest prepared — and frozen for whitelisting
- [ ] Contract addresses, method signatures, and URLs are the **production-ready** ones; no post-whitelisting changes planned
- [ ] npm versions pinned exactly, `ignore-scripts=true` in `.npmrc`, lockfile committed, frozen installs in CI
- [ ] All contracts verified on Celoscan
- [ ] Sample transaction hashes collected for every method
- [ ] Redirects to Deposit deeplink on insufficient balance
- [ ] In-app support link (Telegram / WhatsApp / email / web portal)
- [ ] Committed to 24h SLA for critical fixes
- [ ] App name + logo visible and clearly distinct from MiniPay's branding
- [ ] Terms of Service + Privacy Policy + Support/Contact + **About** + **How to Use** all reachable from footer or menu
- [ ] Developer name / organisation displayed, with an explicit "operated by us, not by Opera or MiniPay" statement
- [ ] **Stats / analytics page** published — DAU, MAU, retention, tx volume per stablecoin, network fees paid, protocol fees / revenue, failed-tx rate, tx counts per day / week / month / lifetime
- [ ] **AI support agent on Telegram** (recommended) — intakes tickets, categorises by type + criticality (P0–P3), drafts resolutions for human approval, tracks SLA

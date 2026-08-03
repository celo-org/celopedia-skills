# MiniPay App Fit & Priority Framework

> **Who this is for:** Founders and builders deciding whether to build a Mini App for MiniPay —
> and how to prioritise effort if they do.
>
> **What it answers:** "Should I target MiniPay?", "How strong is my product-channel fit?",
> "Which category gives me the best chance of listing?", and "What will block me before I even submit?"
>
> **Data sources:** `minipay-live-apps.md` (catalog snapshot) · `minipay-requirements.md`
> (official submission checklist) · `minipay-guide.md` (technical constraints).

> ⚠️ **Read this first — two questions, not one.** A high score below means your idea has strong
> **MiniPay channel fit** (it would work well *inside* MiniPay). It does **not** mean the idea has
> validated **demand**. These are independent axes:
>
> - **MiniPay Channel Fit** — would it work well in MiniPay's UX, tokens, and constraints? (§2 scorecard)
> - **Demand Evidence** — is there evidence people actually want this, and a path to the first dollar? (§3)
>
> An idea can be a perfect channel fit and still fail because nobody needed it. The most common
> failure mode is building on channel fit alone, then discovering after launch that the market never
> existed (e.g. a local-stablecoin app that MiniPay does not prioritise, or a "buy X" app in a market
> where no rail funds the wallet). **Score channel fit, then evidence demand, then decide.**

---

## 0. Understand Your Builder Profile First

Before scoring your idea, answer these questions honestly. Your profile changes what you should build.

**Q1 — How mature is your app?**
- I have an idea / prototype → **First-time or early builder**
- I have live users and traction → **Established builder**

**Q2 — Do you have a background in the domain you're building in?**
- Yes (e.g. fintech, trading, lending) → **Domain expert**
- No → **Domain generalist**

**Q3 — Does your app involve B2B relationships (partnerships, white-label, enterprise)?**
- Yes → You need to show existing traction and contracts. Without them, MiniPay is not the right channel yet.
- No → Continue to scorecard.

**What this means for your recommendations:**

| Profile | Best path |
|---------|-----------|
| First-time founder, no traction | Start with **x2earn games** or **pay-as-you-go AI tools** — low regulatory risk, fastest to ship, high demand |
| Domain expert in fintech / tradfi, existing users | Financial apps (savings, credit, FX) are viable — but require proper licensing in each market you serve |
| Second-time founder with tradfi background | More options open, including credit/lending — still requires compliance |
| B2B app, no traction yet | Not a good MiniPay fit right now. Come back when you have live users |
| B2B app, proven traction | Strong fit — MiniPay gives you direct reach to 14M+ wallets |

> ⚠️ **Financial apps (credit, lending, savings, FX) require licensing in most MiniPay primary markets.** Building without proper compliance puts your users at risk and your app at risk of removal. If you are not established in the domain, default to games or AI pay-as-you-go instead.

---

## 1. Who Is the MiniPay User?

Before scoring your idea, know the person on the other end of the screen.

| Dimension | Reality |
|-----------|---------|
| **Geography** | Global South — Nigeria, Kenya, Uganda, Ghana, South Africa, Brazil, Colombia, Philippines (60+ countries) |
| **Device** | Budget Android (most common), basic iOS. Expect small screens, low RAM |
| **Connectivity** | Intermittent, low bandwidth. 2G/3G is common in primary markets |
| **Financial profile** | Unbanked or underbanked. Stablecoins serve as the primary savings and payment tool |
| **Stablecoins available** | USDm, USDC, USDT. Network fees are handled automatically |
| **Crypto literacy** | Non-crypto-native. Terms like "gas", "onramp", "wallet address", and "blockchain" are UX failures |
| **Session length** | Short. Single-handed use on mobile, often in noisy or low-attention environments |

**The core implication:** Apps that solve real everyday problems (paying for things, earning income, sending money, accessing services) for non-crypto users win in MiniPay. Apps that require crypto knowledge, long forms, or heavy UI lose.

---

## 2. Channel-Fit Scorecard

Score your idea on 5 dimensions (0–2 each). Total out of 10. **This measures MiniPay channel fit only** —
whether the idea works *inside* MiniPay. It says nothing about demand; that is §3.

### A. Stablecoin-native
Does the core value of your app involve sending, receiving, saving, or earning USDm / USDT / USDC?

| Score | What it means |
|-------|---------------|
| **2** | The core user flow is entirely in stablecoins — users earn, spend, or move USDm/USDT/USDC |
| **1** | Stablecoins are present but secondary to the main experience |
| **0** | The app does not involve stablecoin transactions at all |

> **Note:** Network fees are handled automatically by MiniPay via CIP-64 fee abstraction — users can see the fee by tapping Info on the transaction approval screen, but never need to manage it manually. CELO should not be prominent in your UI. See `builder-guide.md` → *Allowed Fee Currencies (Mainnet)*.

---

### B. Short-session friendly
Can the primary action be completed in under 60 seconds on a budget Android?

| Score | What it means |
|-------|---------------|
| **2** | Core action takes ≤ 3 taps, works reliably on a slow connection |
| **1** | 4–7 steps, requires decent connectivity |
| **0** | Multi-step flow, data-heavy UI, or complex input required |

> Budget Android users on 3G have a very low tolerance for loading times and form friction. Every extra tap is potential churn. Keep the happy path ruthlessly short.

---

### C. Local market fit
Does your app address a need that is acute in at least one of MiniPay's primary markets?

| Score | What it means |
|-------|---------------|
| **2** | Directly solves a known, documented pain point in a specific target market — describe which country and why |
| **1** | Useful broadly but not specifically designed for Global South or emerging market users |
| **0** | Designed primarily for users who already have banking infrastructure |

**Example everyday pain points by market:**

| Country | Acute need |
|---------|-----------|
| 🇳🇬 Nigeria | Airtime top-up, bill payment, peer money transfer, earning in USD |
| 🇰🇪 Kenya | Micro-savings, small business payments, mobile-first commerce |
| 🇧🇷 Brazil | Fast peer payments, earning opportunities, everyday commerce |
| 🇨🇴 Colombia | Gig worker payouts, peer-to-peer transfers, everyday services |
| 🇵🇭 Philippines | Remittances, digital tipping, mobile-first earning |
| 🇿🇦 South Africa | Township commerce, peer payments, informal savings groups (stokvels) |

> **When filling this dimension:** name the specific country, the pain point, and why your app addresses it better than what already exists in that market.
>
> ⚠️ **Licensing reminder:** financial use cases in these markets (payments, savings, lending, FX) require proper local licensing. These categories should not be pursued without compliance and domain expertise — they are not yet fully covered by MiniPay's offer.

---

### D. Works without `personal_sign`
MiniPay does not support `personal_sign` or `eth_signTypedData`. Can your app work without them?

| Score | What it means |
|-------|---------------|
| **2** | Wallet address is sufficient for the core flow — no off-chain signature required |
| **0** | Requires `personal_sign` or `eth_signTypedData` — **this is a hard technical block; the app cannot function in MiniPay** |

> **Note:** Apps can still collect user data (email addresses, phone numbers, profile info) through regular forms — that is fully supported. This dimension is only about cryptographic signing methods.
>
> **Auto-connect is mandatory inside MiniPay.** Never show a "Connect Wallet" button when `window.ethereum.isMiniPay === true`. See `minipay-guide.md` → *Wallet Connection*.
>
> Need phone-number → wallet address resolution? ODIS / FederatedAttestations is supported and recommended — see `odis-socialconnect.md`. This adds setup complexity but does not block your score.

---

### E. Catalog whitespace
Is your category underserved in the MiniPay Discovery catalog right now?

| Score | What it means |
|-------|---------------|
| **2** | Category has 0–1 existing apps, or the one app that exists is geo-blocked in your target market |
| **1** | 2–4 competitors, but your angle is meaningfully differentiated |
| **0** | Highly competitive category with no clear differentiation angle |

> See `minipay-live-apps.md` for the current catalog snapshot with per-country availability data.
>
> ⚠️ **Whitespace is not demand.** An empty category can mean an untapped opportunity **or** that no
> one wants it there. Zero competitors is ambiguous on its own — score it here as *channel* signal, then
> confirm real demand separately in §3 before treating it as a reason to build.
>
> **A live listing proves availability, not traction or problem resolution.** The catalog snapshot
> shows what exists, not what works, retains users, or has solved the problem — never infer demand from
> presence in the catalog.

---

## 3. Demand Evidence & Source of Funds (evaluate separately — do not add to the §2 score)

Two independent checks. Neither adds to your channel-fit score; **either one can veto a "build now."**
Channel fit tells you the idea *fits the channel*; these tell you whether it's worth building at all.

### Demand evidence
Rate the strongest evidence you actually have that people want this. Higher is better.

| Level | What it means |
|-------|---------------|
| **MiniPay-requested** | MiniPay / Celo has explicitly asked for this (official wishlist, partner ask, team callout) |
| **Observed in MiniPay** | Users already do a workaround inside MiniPay, or an existing listing shows pull for this need |
| **Locally validated** | You have talked to real target-market users who have this problem and want a fix (interviews, waitlist, pilot) |
| **External analogy only** | It worked in another ecosystem/market; no direct evidence in the MiniPay market yet |
| **Speculative** | "It should work" — no evidence beyond intuition |

> **External analogy only** or **Speculative** ⇒ *validate before building*, no matter how high your
> channel-fit score is. "It worked on [other chain/market]" is a hypothesis, not demand. Run the
> cheapest test that could invalidate it before writing an MVP.

### Source of funds — who puts the first dollar in the wallet, and why?
Every savings, payments, investment, remittance, or commerce idea dies if no real rail funds the wallet
in your target market. Name the source explicitly.

| Source | You must verify |
|--------|-----------------|
| Remittance | The corridor + rail actually reaches MiniPay wallets in that market |
| Salary / freelance payout | A payer exists who will pay into the wallet |
| Merchant revenue | Merchants accept and settle in stablecoins there |
| Rewards / gaming | The reward budget is real and sustainable, not a one-off incentive |
| Stablecoins the user already holds | The user already has a funded balance (rare for new users) |
| Manual on-ramp | ⚠️ The on-ramp rail actually works in the target market — the most common silent failure |
| Ecosystem incentives | Funding ends when the program ends — not a durable source |

> **If the answer is "the user funds it manually," stop and check the rail.** A "buy X" or savings app
> is only as real as the cheapest way its users get money into the wallet. Confirm the specific
> on-ramp/rail works in the specific country **before** building — see `stablecoin-orchestration.md`
> for which rails are live vs. Beta per market (e.g. COP via Bre-B/PSE/ACH is still Beta).

---

## 4. Recommendation — combine channel fit with demand

Read your §2 total against your §3 demand evidence. **Do not** collapse this into a single number.

| §2 channel fit | §3 demand evidence | Recommendation |
|----------------|--------------------|----------------|
| 8–10 | Locally validated or stronger, funded source | 🟢 **Build now** — strong channel fit *and* evidenced demand. Get a Celo team review before submitting. |
| 8–10 | External analogy / Speculative | 🟡 **Strong MiniPay channel fit — validate demand first.** Run the cheapest invalidating test and confirm the funding rail before building. |
| 5–7 | any | 🟡 **Build, fix the gaps.** Find your lowest §2 score, fix it; in parallel raise demand evidence. |
| any | no viable source of funds | 🟠 **Blocked by funding rail.** No real way to get the first dollar into the wallet in this market — fix the rail question or pick another market before building. |
| 3–4 | any | 🟠 **Validate before committing.** Test with real users via ngrok; consider Proof of Ship for feedback first. |
| 0–2 | any | 🔴 **Wrong channel for now.** Structural mismatch with MiniPay. Pivot the concept or choose a different channel. |

> The old "score → single tier" table conflated *fits the channel* with *worth building*. High channel
> fit with speculative demand is **not** a green light — it's a signal to validate cheaply first.

---

## 5. Category Opportunity Map

Current catalog density from `minipay-live-apps.md` (snapshot — verify before using).

> ⚠️ **"Opportunity" here means catalog whitespace, not measured demand.** A category marked 🟢 High is
> *under-covered*, which is a channel signal — pair it with §3 demand evidence before treating it as a
> reason to build. Low coverage can equally mean low demand.

| Category | Apps live | Opportunity | Notes |
|----------|-----------|-------------|-------|
| **Games** | 11 | 🟢 High | Easiest to build and launch; strong Celo interest; novel mechanics (skill-based, local IP, cultural context) differentiate |
| **Rewards / earn** | 10 | 🟢 High | High interest from Celo; differentiated earning mechanics have strong potential |
| **Pay AI as you go** | 0 | 🟢 High | No apps yet. Pay-per-use AI tools with stablecoin micropayments are a strong fit for MiniPay's UX model |
| **Social** | 0 | 🟢 High | No social app listed — but requires network effects, plan for user acquisition from day one |
| **Health / fitness** | 1 | 🟢 High | Only Squadletics. Large green field |
| **News / media** | 1 | 🟢 High | Only Briefing. Untapped |
| **Shopping** | 1 | 🟢 High | E-commerce + stablecoins is open — **only if you already have users/traction** |
| **Utility** | 8 | 🟡 Medium | Bill pay led by Bitgifty and Fonbank (Nigeria-focused). Check which markets they do not cover — that gap is your opportunity |
| **Sports** | 4 | 🟢 High | Africa-focused. Opportunities in other markets |
| **Finance — savings/FX** | 7 | 🟠 Established builders only | Many markets underserved, but this space suits teams with existing users and relevant domain background |
| **Finance — credit/lending** | 0 | 🔴 Requires licensing | Massive market need, but requires financial licensing in each market. Not recommended without legal compliance and domain expertise |

---

## 6. Things to Fix Before Submitting

These are technical constraints that need to be addressed before your app can function correctly in MiniPay. All of them are fixable — address them during development.

| Item | What to do |
|---|---|
| App uses `personal_sign` | Replace with wallet-address-only identity or ODIS phone resolution. See `odis-socialconnect.md`. |
| App uses `eth_signTypedData` | Replace with a flow that only requires `eth_sendTransaction`. |
| App displays CELO balance or requires CELO payment | Remove CELO from your UI entirely. MiniPay handles gas automatically — users never see it. |
| App sets EIP-1559 transaction fields | Remove `maxFeePerGas` / `maxPriorityFeePerGas`. Use legacy transaction format. |
| Bundle size > 2 MB or heavy images | Use SVG/WebP, lazy-load aggressively, and keep your initial JS bundle small. |

---

## 7. Pre-fit Checklist (run before scoring)

Before applying the scorecard, answer these questions. A single "No" on items 1–3 is an immediate Tier 4:

- [ ] Can the entire core user flow run inside MiniPay's WebView?
- [ ] Can you build the UI without showing CELO or raw `0x…` addresses?
- [ ] Can a non-crypto user understand what the app does from the first screen?

---

## 8. Example Score — Reference

The table below shows a worked example for orientation. Replace with your own app's values.
Note the two separate axes: the scorecard measures **channel fit**; demand and funding are read alongside it.

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| A. Stablecoin-native | 2 | All payments and rewards denominated in USDm, USDT, or USDC |
| B. Short-session | 2 | Core action (3 taps): choose → confirm → done |
| C. Local market fit | 2 | Directly solves a documented pain point in a specific primary market |
| D. No `personal_sign` | 2 | Wallet address = identity; no `personal_sign` anywhere |
| E. Catalog whitespace | 2 | Category has zero or one Celo-native apps |
| **Channel-fit total** | **10 / 10** | Strong MiniPay channel fit |

Now read it against §3 (evaluated separately, **not** added to the 10):

| Separate check | Value | So what |
|----------------|-------|---------|
| Demand evidence | Locally validated (20 target-market user interviews + waitlist) | Evidence is real, not analogy |
| Source of funds | Salary payout — a documented payer pays into the wallet | The first dollar has a verified rail |
| **Recommendation** | — | **🟢 Build now** (§4) — strong channel fit *and* evidenced, funded demand |

> Had demand been *External analogy only* or the funding source *manual on-ramp with no verified rail*,
> the same 10/10 channel fit would read **🟡 validate first** or **🟠 blocked by funding rail** — not build now.

---

## Related References

- `minipay-guide.md` — Detection, auto-connect, stablecoin transfers, deeplinks, ngrok testing
- `minipay-requirements.md` — Official submission checklist (copy rules, PageSpeed, ToS/Privacy, SLA)
- `minipay-live-apps.md` — Full catalog snapshot with country availability data
- `minipay-templates.md` — Ready-to-copy code for common Mini App patterns
- `minipay-scaffold-from-scratch.md` — Minimal Next.js + viem setup without Celo Composer
- `odis-socialconnect.md` — Phone number → address resolution via ODIS / FederatedAttestations
- `builder-guide.md` — Fee abstraction (CIP-64), feeCurrency adapter addresses, SDK selection

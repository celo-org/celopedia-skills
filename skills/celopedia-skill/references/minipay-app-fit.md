# MiniPay App Fit & Priority Framework

> **Who this is for:** Founders and builders deciding whether to build a Mini App for MiniPay —
> and how to prioritise effort if they do.
>
> **What it answers:** "Should I target MiniPay?", "How strong is my product-channel fit?",
> "Which category gives me the best chance of listing?", and "What will block me before I even submit?"
>
> **Data sources:** `minipay-live-apps.md` (catalog snapshot) · `minipay-requirements.md`
> (official submission checklist) · `minipay-guide.md` (technical constraints).

---

## 1. Who Is the MiniPay User?

Before scoring your idea, know the person on the other end of the screen.

| Dimension | Reality |
|-----------|---------|
| **Geography** | Global South — Nigeria, Kenya, Uganda, Ghana, South Africa, Brazil, Colombia, Philippines (60+ countries) |
| **Device** | Budget Android (most common), basic iOS. Expect small screens, low RAM |
| **Connectivity** | Intermittent, low bandwidth. 2G/3G is common in primary markets |
| **Financial profile** | Unbanked or underbanked. Stablecoins serve as the primary savings and payment tool |
| **Stablecoins available** | USDm, USDC, USDT only. CELO is hidden from users and handled automatically |
| **Crypto literacy** | Non-crypto-native. Terms like "gas", "onramp", "wallet address", and "blockchain" are UX failures |
| **Session length** | Short. Single-handed use on mobile, often in noisy or low-attention environments |

**The core implication:** Apps that solve real-money problems (paying bills, earning income, sending money, accessing credit, saving) for non-crypto users win in MiniPay. Apps that require crypto knowledge, long forms, or heavy UI lose.

---

## 2. App Fit Scorecard

Score your idea on 6 dimensions (0–2 each). Total out of 12.

### A. Stablecoin-native
Does the core value of your app involve sending, receiving, saving, or earning USDm / USDT / USDC?

| Score | What it means |
|-------|---------------|
| **2** | The core user flow is entirely in stablecoins — users earn, spend, or move USDm/USDT/USDC |
| **1** | Stablecoins are present but secondary to the main experience |
| **0** | The app does not involve stablecoin transactions at all |

> **Note:** The CELO token must never appear in your UI. MiniPay handles network fees automatically via CIP-64 fee abstraction — see `builder-guide.md` → *Allowed Fee Currencies (Mainnet)*.

---

### B. No-crypto UX possible
Can you build this without exposing blockchain concepts to the user?

| Score | What it means |
|-------|---------------|
| **2** | Users never see "wallet", "gas", "chain", "token", "smart contract", or a raw `0x…` address |
| **1** | Some crypto vocabulary is visible but can be explained in plain language (e.g. "digital dollars") |
| **0** | The app requires users to understand blockchain mechanics to complete the core flow |

> MiniPay enforces specific copy rules. Replace: "Gas fee" → **Network fee** · "Onramp" → **Deposit** · "Offramp" → **Withdraw** · "Crypto" → **Stablecoin** or **Digital dollar**. See `minipay-requirements.md` §3.

---

### C. Short-session friendly
Can the primary action be completed in under 60 seconds on a budget Android?

| Score | What it means |
|-------|---------------|
| **2** | Core action takes ≤ 3 taps, works reliably on a slow connection |
| **1** | 4–7 steps, requires decent connectivity |
| **0** | Multi-step flow, data-heavy UI, or complex input required |

> Budget Android users on 3G have a very low tolerance for loading times and form friction. Every extra tap is potential churn. Keep the happy path ruthlessly short.

---

### D. Local market fit
Does your app address a need that is acute in at least one of MiniPay's primary markets?

| Score | What it means |
|-------|---------------|
| **2** | Directly solves a known, documented pain point in a specific target market — describe which country and why |
| **1** | Useful broadly but not specifically designed for Global South or emerging market users |
| **0** | Designed primarily for users who already have banking infrastructure |

**Example pain points by market:**

| Country | Acute need |
|---------|-----------|
| 🇳🇬 Nigeria | Bill payment, airtime top-up, USD savings against naira inflation |
| 🇰🇪 Kenya | Micro-savings, remittance corridors, small business payments |
| 🇧🇷 Brazil | Credit access, PIX-equivalent instant payments, inflation hedging |
| 🇨🇴 Colombia | Cross-border payments, gig worker payouts, USD savings |
| 🇵🇭 Philippines | OFW remittances, informal lending, digital tipping |
| 🇿🇦 South Africa | Informal savings groups (stokvels), township commerce |

> **When filling this dimension:** name the specific country, the pain point, and why your app addresses it better than what already exists in that market.

---

### E. No-sign-in possible
MiniPay does not support `personal_sign` or `eth_signTypedData`. Can your app work without them?

| Score | What it means |
|-------|---------------|
| **2** | Wallet address alone is sufficient identity — no off-chain auth required |
| **1** | Needs phone-number → address resolution via ODIS / FederatedAttestations (supported, but adds setup complexity — see `odis-socialconnect.md`) |
| **0** | Requires `personal_sign` or `eth_signTypedData` — **this is a hard technical block; the app cannot function in MiniPay** |

> **Auto-connect is mandatory inside MiniPay.** Never show a "Connect Wallet" button when `window.ethereum.isMiniPay === true`. See `minipay-guide.md` → *Wallet Connection*.

---

### F. Category gap in current catalog
Is your category underserved in the MiniPay Discovery catalog right now?

| Score | What it means |
|-------|---------------|
| **2** | Category has 0–1 existing apps, or the one app that exists is geo-blocked in your target market |
| **1** | 2–4 competitors, but your angle is meaningfully differentiated |
| **0** | Saturated category (games: 11 apps, rewards: 10 apps) with no clear differentiation |

> See `minipay-live-apps.md` for the current catalog snapshot with per-country availability data.

---

## 3. Priority Tiers

| Total Score | Priority | What to do |
|-------------|----------|------------|
| **10–12** | 🟢 **Tier 1 — Build now** | Strong product-channel fit. Prioritise MiniPay Discovery as your primary distribution channel. After building, get a Celo team review before submitting. |
| **7–9** | 🟡 **Tier 2 — Build with caveats** | Good fit with specific gaps. Identify your lowest-scoring dimension and address it before submission. |
| **4–6** | 🟠 **Tier 3 — Validate first** | Partial fit. Run an ngrok test with real users in your target market before committing. Consider entering Proof of Ship to get feedback from the Celo community. |
| **0–3** | 🔴 **Tier 4 — Wrong channel** | Structural mismatch with MiniPay constraints. Pivot the product concept or choose a different distribution channel. Proof of Ship is a good environment for this pivot. |

---

## 4. Category Opportunity Map

Current catalog density from `minipay-live-apps.md` (snapshot — verify before using):

| Category | Apps live | Opportunity | Notes |
|----------|-----------|-------------|-------|
| **Social** | 0 | 🟢 High | No social app listed. First mover in a 14M-wallet network |
| **Finance — credit/lending** | 0 | 🟢 High | No credit app. Massive need in all primary markets |
| **Finance — savings/FX** | 7 | 🟢 High | LATAM almost entirely uncovered |
| **Prediction / betting** | 2 | 🟢 High | Main competitor (Predictor) blocked in BR, AR, GB, TH, VN, MY, PH |
| **Shopping** | 1 | 🟢 High | Only one app. E-commerce + stablecoins is open |
| **Health / fitness** | 1 | 🟢 High | Only Squadletics. Large green field |
| **News / media** | 1 | 🟢 High | Only Briefing. Untapped |
| **Games** | 11 | 🟡 Medium | Competitive, but novel mechanics (skill-based, local IP, cultural context) can still win |
| **Rewards / earn** | 10 | 🔴 Saturated | Highest competition. Only enter with a structurally different earning mechanic |
| **Utility** | 8 | 🟡 Medium | Bill pay dominated by Nigeria-focused apps. Other markets open |
| **Sports** | 4 | 🟡 Medium | Africa-focused. LATAM sports app gap exists |

---

## 5. Geo Priority Map

| Region | Countries | MiniPay penetration | Catalog coverage | Best categories to target |
|--------|-----------|---------------------|-----------------|--------------------------|
| **West Africa** | NG, GH, SL, CI | 🔴 High — most apps already here | Mostly covered | New mechanics in games, health, news |
| **East Africa** | KE, UG, TZ, RW | 🟡 Medium | Partially covered | Finance, savings, sports |
| **LATAM — Brazil** | BR | 🟢 Low | Almost nothing | Prediction, finance, social, shopping |
| **LATAM — Andean** | CO, AR, PE, CL | 🟢 Low | Almost nothing | Prediction, finance, remittance |
| **Southeast Asia** | PH, ID | 🟡 Medium | Partial | Remittance, micro-lending |
| **Southern Africa** | ZA, MW, ZM | 🟢 Low | Almost nothing | Finance, savings, informal commerce |

> **LATAM is the single biggest opportunity right now.** High MiniPay user base, almost no apps targeting the region, and the main prediction-market competitor is geo-blocked in Brazil and Argentina.

---

## 6. Automatic Disqualifiers

These are hard technical constraints. They are **not fixable with UX changes** — they require architectural decisions before building.

| Disqualifier | Why it blocks you |
|---|---|
| App requires `personal_sign` | MiniPay does not support this method. Any flow that needs off-chain signatures (login, permit, typed auth) will silently fail or error. |
| App requires `eth_signTypedData` | Same as above — not supported by the MiniPay wallet. |
| App displays CELO balance or requires CELO payment | MiniPay hides CELO from users entirely. Displaying it breaks the UX contract and will get your app rejected from Discovery. |
| App only works with EIP-1559 transaction fields | MiniPay uses legacy transactions only. Do not set `maxFeePerGas` or `maxPriorityFeePerGas`. |
| App can only be tested in an emulator | MiniPay requires a physical device running Android or iOS. If your team cannot test on-device, do not submit yet. |
| Bundle size > 2 MB or heavy images | Low-bandwidth users will abandon. Use SVG/WebP, lazy-load aggressively, and keep your initial JS bundle small. |

---

## 7. Pre-fit Checklist (run before scoring)

Before applying the scorecard, answer these questions. A single "No" on items 1–4 is an immediate Tier 4:

- [ ] Can the entire core user flow run inside MiniPay's WebView without external app switching?
- [ ] Does your app work without `personal_sign` or `eth_signTypedData`?
- [ ] Can you build the UI without showing CELO or raw `0x…` addresses?
- [ ] Is your app testable on a physical device via ngrok?
- [ ] Can a non-crypto user understand what the app does from the first screen?

---

## 8. Example Score — Reference

The table below shows a worked example for orientation. Replace with your own app's values.

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| A. Stablecoin-native | 2 | All payments and rewards denominated in USDm or USDT |
| B. No-crypto UX | 2 | "Network fee" not "gas"; no addresses shown; no crypto jargon in UI copy |
| C. Short-session | 2 | Core action (3 taps): choose → confirm → done |
| D. Local market fit | 2 | Targets Brazil specifically; fills a gap left by a geo-blocked competitor |
| E. No-sign-in | 2 | Wallet address = identity; no `personal_sign` anywhere |
| F. Category gap | 2 | Category has zero Celo-native apps; main competitor geo-blocked |
| **Total** | **12 / 12** | **🟢 Tier 1 — Build now** |

---

## Related References

- `minipay-guide.md` — Detection, auto-connect, stablecoin transfers, deeplinks, ngrok testing
- `minipay-requirements.md` — Official submission checklist (copy rules, PageSpeed, ToS/Privacy, SLA)
- `minipay-live-apps.md` — Full catalog snapshot with country availability data
- `minipay-templates.md` — Ready-to-copy code for common Mini App patterns
- `minipay-scaffold-from-scratch.md` — Minimal Next.js + viem setup without Celo Composer
- `odis-socialconnect.md` — Phone number → address resolution via ODIS / FederatedAttestations
- `builder-guide.md` — Fee abstraction (CIP-64), feeCurrency adapter addresses, SDK selection

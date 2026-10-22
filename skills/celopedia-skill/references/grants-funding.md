# Celo Grants & Funding Programs

> Source: https://www.celopg.eco/programs
> Additional: https://docs.celo.org/build-on-celo/fund-your-project
> Last updated: 2026-08-28 (cache — always fetch live per directive below)

> ⚠️ **Live data required.** Program status (Live/Past), dates, rewards, and eligibility change frequently — often mid-quarter. **Always fetch the current list from `https://www.celopg.eco/programs` before answering any grant question.** The tables below are a cached reference and may be stale the moment a program's status flips. See `live-data-sources.md` §2 for the fetch command. For eligibility / submission cadence / rewards, extract from the live page — do not infer from this file.

---

## Currently Live Programs

> **Proof of Ship has been sunset** and is no longer accepting submissions. For hackathon and
> new-program announcements, subscribe to the Celo Devs newsletter: https://celo-devs.beehiiv.com/subscribe

### Agents on Open Rails Hackathon

- **Type**: Hackathon
- **Amount**: **$5,000 total**, distributed in $CELO
- **Dates**: **Oct 6, 2026 – Nov 9, 2026**; submission window 2026-10-06T12:00Z → 2026-11-09T09:00Z
- **Host**: Celo Devs
- **Platform**: Loops House
- **Kick-off recording** (Oct 6 livestream): https://www.youtube.com/watch?v=ik4_h2hhDME
- **Build with buy launch livestream** (Oct 13, with partners Cencori, Chainstack, and SQD; covers the buy track): https://www.youtube.com/live/w1A_mP3r8aQ
- **Ripio track livestream** (Oct 8): https://www.youtube.com/watch?v=kjRJUaf1Fgo
- **buy demo** (from the Agents at Work beta tests, not this hackathon's launch): https://youtu.be/tn0tDEOwqgg
- **Announcement**: https://x.com/CeloDevs/status/2107440784534561278
- **Partners**: Ripio, Textile FX, buy, Chainstack, and Prezenti
- **Tracks**:

  | Track | Prize | Focus |
  |-------|-------|-------|
  | Stable Agents: LatAm | $2,000 | Agents for real users on Ripio's wFIAT rails |
  | Open Corridors | $2,000 | FX agents on Textile + real settlement in USA₮ via Celo's x402 |
  | Build with `buy` | $1,000 | Best projects leveraging buy's agent service marketplace |

- **Register / details**: https://www.loops.house/agents-on-open-rails/ (enrolment is behind a Loops House login — not via the Celo Builders skill). Telegram: https://t.me/realworldagentshackathon · Office hours: Thursdays 12:00 GMT. Regional builder sessions: Oct 17 in six Argentine cities (Celo Core Co. and Ripio).
- **Required stack**: an **ERC-8004** identity for every entry; the **ERC-8021 attribution tag** (issued when you enrol) in place **before the first transaction** (it cannot be backfilled — see [attribution-tags.md](attribution-tags.md)); **Celo mainnet only**; public GitHub repo at registration that still resolves at judging; code written during the hackathon. You can enter several tracks but win one prize per track.
- **Independent users**: a wallet that is not yours, was not first funded by you or your main funder, and had its own Celo activity before the hackathon started. Wallets made just for the hackathon don't count; gasless flows are fine (signers/authorisers count); sponsored gas is not a builder contribution.
- **Scoring**: live leaderboard queries plus a human panel that reviews the repo (per the hackathon page). **Build with buy** entries must state which services they used and provide payment proof; spamming the cheapest calls scores nothing, and independent users are a qualifier. Gas a relayer pays on your behalf does not count as builder contribution — disclose it in your submission. A project that fits no track should enter the closest one and say so in the submission.
- **x402 + wFIAT gotchas**: the hosted Celo x402 facilitator lists all six Ripio wFIAT tokens (Permit2, as of 2026-10-21) — see [ai-agents.md](ai-agents.md) → _Hosted Celo Facilitator_. **x402 settlements cannot carry an attribution tag yet** (see [attribution-tags.md](attribution-tags.md)); for x402 transactions the hackathon page asks you to provide your **PayTo wallet address** instead. Sellers get an API key with 20 free mainnet settlements.
- **Naming**: the hackathon page writes **USA₮**; this skill calls the same token **USAT** (address in [contracts.md](contracts.md)).
- **Track resources** (per the hackathon page): *LatAm* — wFIAT tokens are 18 decimals; on-ramp via `ramp.ripio.com` with query parameters (no credentials needed by the builder; the buyer still does KYC with Ripio, AR/BR/MX/CO only) or the Ripio Ramps API (needs a registered legal entity at platform.ripio.com), and the bridge at `bridge.ripio.com`. *Textile FX* — a permissionless onchain FX marketplace for cNGN, wARS, wBRL, and USDC against USD₮ (https://app.textilecredit.com). Getting each wFIAT on Celo, by token and by builder location: [wfiat-access.md](wfiat-access.md). *USA₮* — eligible users can get USA₮ from the Google Cloud Web3 faucet after verifying with Self on Celo mainnet.
- **Perks** (per the hackathon page): 3 months of Chainstack's Growth Plan free for every team; Prezenti grants (the page cites $165K for the season — confirm on prezenti.xyz); Builder Graph rating and Certify credential for every submission; co-marketing and mentorship for winners; winning agents listed in a curated Celo set on Aigora.

### Prezenti: Season 3

- **Type**: Milestone-based grants, three pools
- **Amount**: **$25K+ USD** (Anchor: $25K stage 2, $50K stage 3, case-by-case stage 4)
- **Dates**: listed as **Aug 12 – Dec 29, 2026**
- **Host**: Prezenti
- **Pools**: **Anchor** (teams with proven traction, open application) · **Frontier** (AI & agent-economy infrastructure, open application) · **Boost** (invite only, fast-track deployment from other ecosystems, with the Celo Foundation)
- **Apply**: https://anchor.prezenti.xyz/ · https://frontier.prezenti.xyz/
- **Timeline**: decisions within 2–4 weeks, rolling until funds are allocated
- **⚠️ Status is contradictory at source — check before pointing anyone here.** As of 2026-08-28, prezenti.xyz shows the Season 3 Anchor round as "Open 12th Aug 2026 – 29th Dec 2026" while the same page also says "We are currently closed for applications. Season 3 has concluded." Both statements are on the live site; this file does not resolve which is right. Confirm directly before advising a builder to apply.
- **Note**: Prezenti encourages applicants to **discuss fit before applying**.

### Celo Builder Fund

- **Type**: Investment via **Uncapped YC SAFE**
- **Amount**: **$25K per project** (10–15 projects targeted)
- **Dates**: Year-round, runs through **Dec 31, 2026**
- **Host**: Celo Growth team
- **Source**: https://www.celopg.eco/programs/celo-builder-fund
- **Best for**: Projects in the **post-launch phase** (live MVP or v1) that are deployed to **Celo mainnet** with active GitHub development
- **Eligibility — must meet at least 2 of 4 traction thresholds:**
  - **1,000+ MAUs** (measured via on-chain usage or app analytics)
  - **500+ daily transactions** sustained over a 2-week period
  - **$50K+ TVL** (locked liquidity or usage-based lending/borrowing)
  - **$5K+/month revenue** (total transaction volume or net GMV revenue)
- **What's provided**: $25K seed funding, strategic growth support from the Celo Growth team, ecosystem exposure and investor introductions
- **Graduation**: Projects hitting 10K+ MAU, $250K+ TVL, and sustained traction may access larger capital through **Verda**
- **Required materials**: a deck and/or product demo plus quantitative traction data
- **Contact**: lena.hierzi@celo.org

---

## Past Programs (from celopg.eco)

| Program | Funding | Dates | Host |
|---------|---------|-------|------|
| Agents at Work | $5K CELO | Aug 28 – Sep 14, 2026 | Celo Devs |
| Onchain Agents Hackathon | $5K CELO | May 22 – Jun 15, 2026 | Celo DevRel |
| Synthesis | 10K USDT | Mar 11–25, 2026 | Celo Devs |
| Build Agents for Real World | $8.5K USDT | Mar 2–22, 2026 | Celo Public Goods |
| Cel'EU Cirkvit S1 | 27K CELO | Nov–Dec 2025 | Celo Europe |
| Gitcoin Grants 24 | $1.5M USD | Oct–Dec 2025 | Celo Public Goods |
| Mini App Mondays | 250 + 1K CELO/week | Sep–Dec 2025 | Celo Devs |
| Prezenti Peach Round | Up to 50K USD | Aug–Dec 2025 | Prezenti |
| Support Streams S1 | 150K CELO + 150K OP | Sep 2025–Jan 2026 | Celo Public Goods |
| Proof of Impact S1 | 250K CELO + 100K OP | Aug–Dec 2025 | Celo Public Goods |
| GoodBuilders Round 2 | $70K G$ + 50K CELO | Jul–Oct 2025 | GoodDollar |
| CeloPG & Farcaster | 50K CELO | May–Jul 2025 | Celo Public Goods |
| USDGLO Flywheel | 6K USDGLO + 10K CELO | Jun–Jul 2025 | Glo Dollar |
| Builder Rewards | 30K CELO | May–Jul 2025 | Celo Public Goods |
| Support Streams S0 | 100K CELO | May–Jul 2025 | Celo Public Goods |
| Prezenti Anchor Round (S2) | Up to 25K USD | Feb–Jun 2026 | Prezenti |
| Prezenti Frontier Pool (S2) | Milestone-based | through Jun 2026 | Prezenti |
| GoodBuilders Season 3 | $50K G$ | Feb–May 2026 | GoodDollar |
| Proof of Impact S0 | 150K CELO | May–Jul 2025 | Celo Public Goods |

> Note: Prezenti applications have **moved from Charmverse to Tally**. Old Charmverse links are inactive — use `https://anchor.prezenti.xyz/` and `https://frontier.prezenti.xyz/` for new submissions. Announcement: https://forum.celo.org/t/prezenti-grant-applications-have-moved-to-tally/13318

---

## Grant Matchmaking Guide

> **Before you apply:** add [attribution tags](attribution-tags.md) to your transactions as early as possible. Celo tracks ecosystem impact via ERC-8021 attribution data and will use it for future reward distribution — programs that reward on-chain usage can only credit what's attributable.

| Building… | Recommended Program |
|-----------|---------------------|
| Project built on Celo, focus on MiniPay | **Prezenti Anchor Pool (S3)** — $25K+ (confirm status, see above) |
| AI agents or agent-economy infrastructure | **Agents on Open Rails Hackathon** — $5K, Oct 6 – Nov 9 2026 · **Prezenti Frontier Pool (S3)** |
| Post-launch app with measurable traction (1K+ MAU / 500+ daily tx / $50K+ TVL / $5K+/mo revenue) | **Celo Builder Fund** — $25K SAFE |

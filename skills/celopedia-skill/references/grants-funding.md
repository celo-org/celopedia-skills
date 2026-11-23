# Celo Grants & Funding Programs

> Sources: https://www.prezenti.xyz (grant pools), https://celo-devs.beehiiv.com/subscribe (program announcements), https://docs.celo.org/build/fund-your-project
> Last updated: 2026-11-23. Prezenti entries were checked against prezenti.xyz and its Anchor and Frontier forms on 2026-11-03. The hackathon entry was checked against its Loops House page on 2026-11-23. `celopg.eco/programs` no longer lists programs (it returns 404), so it is not a source.

> ⚠️ **Live data required.** Dates, amounts and eligibility change. **Check `https://www.prezenti.xyz` and the application forms it links before answering a Prezenti question**, and point builders to the Celo Devs newsletter for hackathons and new programs. The tables below are a cached reference. See `live-data-sources.md` §2 for the fetch command.

---

## Currently Live Programs

> **Proof of Ship has been sunset** and is no longer accepting submissions. For hackathon and
> new-program announcements, subscribe to the Celo Devs newsletter: https://celo-devs.beehiiv.com/subscribe

### Agents Open for Business (hackathon)

- **Type**: Online hackathon on Loops House. Build agents that do real jobs on Celo mainnet.
- **Prize pool**: **$5,000**, set in USD and paid in CELO at the USD equivalent to the payout wallet the team registers. Altana XP is credited by Altana to the wallet the team built with.
- **Dates**: build opens **Fri Nov 20, 2026** (14:00 GMT, kickoff livestream). Submissions close **Mon Dec 7, 2026 at 09:00 GMT**. Winners announced **Fri Dec 11**.
- **Register**: https://www.loops.house/agents-open-for-business (checked 2026-11-23). Enrolling issues the entry's attribution tag.
- **Tracks** (one project can enter all four and win in up to two):
  - **Stablecoin Corridors (Textile FX)**: 1st $1,000, 2nd $600, 3rd $400. Agents that pay, get paid or pay out in local stablecoins, converting on Textile FX between USD₮ and cNGN, IDRX or Ripio's wFIAT (wARS, wBRL, wMXN, wCOP). Needs at least one tagged Textile FX conversion on mainnet in a listed corridor.
  - **Agent Vault: Online & Onchain Checkouts (Self)**: 1st $700, 2nd $300. Agents that sign in, check out and pay on regular websites with Agent Vault, and pay onchain with x402. A card checkout is optional; signing in meets the requirement. See `agent-vault.md`.
  - **Self Agent ID: Verified Agent Payments (Self)**: 1st $700, 2nd $300. Services where Self Agent ID decides which agents get served, paid or limited, with payments through x402. See `self-agent-id.md`.
  - **Altana Agent Wallets (Altana)**: 1st $750 + 25,000 XP, 2nd $250 + 10,000 XP. Product reviews earn 5,000 XP each, up to 10, one per team. Agents that act from a non-custodial Altana wallet under a session key (spend cap, contract allowlist, expiry).
- **Rules**: Celo mainnet only. Every entry registers its agent on ERC-8004 (Self Agent ID recommended). Public GitHub repo at registration that still resolves at judging. An attribution tag (ERC-8021) in every transaction to be counted; it cannot be added later. x402 sellers register their PayTo address at sign-up, since x402 payments do not carry tags yet. Code is written during the hackathon. Sponsored gas is not a builder contribution.
- **Judging**: Celo DevRel shortlists from onchain data and the Loops judge's reading of the repo. Textile and Celo Core Co. judge Stablecoin Corridors, Self judges the Agent Vault and Self Agent ID tracks, Altana judges its own track.
- **Livestreams**: Tue Nov 24 14:00 GMT (Self: Agent Vault and Agent ID), Wed Nov 25 14:00 GMT (Altana), Tue Dec 1 14:00 GMT (Stablecoin Corridors). AskBots reviews of registered projects on Nov 24 and Dec 4.
- **Support**: Telegram group https://t.me/celoagenthackathons, weekly office hours Thursdays at 12:00 GMT.
- **Perks**: 3 months of Agent Vault Plus and 3 months of Chainstack's Growth Plan at no cost to registered teams. Paying for services on buy (`https://usebuy.ai`) is optional and counts as real use.
- **Next step**: a track record here counts when applying to Prezenti (see below).

### Prezenti: Season 3

- **Type**: Milestone-based grants, three pools
- **Amount**: Anchor **$25,000+ USDm**, Frontier **$15,000+ USDm**, Boost invite only
- **Dates**: applications open **Aug 12 to Dec 29, 2026** (prezenti.xyz, checked 2026-11-03)
- **Host**: Prezenti
- **Track record** (per prezenti.xyz): 575+ applications, 120+ grant contracts signed, $2M USDm granted
- **Anchor Pool** (open application): teams with real traction. Stage 2 (10K to 100K daily transactions): about $25K, for Valora apps and Mini Apps. Stage 3 (100K to 500K): about $50K. Stage 4 (500K+): case by case. The form requires 5,000+ daily transactions (2-week moving average, with evidence) and rejects applicants below it. It also asks for a Karma GAP profile and MiniPay listing status.
- **Frontier Pool** (open application): AI and agent economy infrastructure that other builders and agents use, not end-user apps. Focus areas: agent identity and discovery, agent-to-agent transactions, AI-native developer tooling, verification and trust, interoperability. Requires a Celo mainnet deployment, verifiable onchain activity, Self Agent ID, a distribution plan, and ERC-8004 registration (the form's note about AI infrastructure projects is cut off on the page, so confirm that exception with Prezenti). Open source preferred.
- **Boost Pool** (invite only): fast-tracks proven projects from other ecosystems onto Celo, delivered with the Celo Core Co. DevRel team.
- **Payout**: 20% upfront, 80% on completing the milestones. KYC applies (lead applicant and company country; Prezenti is a Canadian company). Funds go to a Celo address.
- **Apply**: https://anchor.prezenti.xyz/ · https://frontier.prezenti.xyz/ (use these forms; the Apply buttons on the prezenti.xyz homepage go to an old H2 2024 page)
- **Status check**: prezenti.xyz displays "open until 29th Dec 2026". The page source also contains an undisplayed line saying applications are closed and Season 3 has concluded. Confirm with Prezenti before telling a builder to apply close to the deadline.

---

## Past Programs

| Program | Funding | Dates | Host |
|---------|---------|-------|------|
| Celo Builder Fund | $25K per project (uncapped YC SAFE) | Listed Jan 1 to Dec 31, 2026; program page removed | Celo Core Co. |
| Agents on Open Rails | $5K CELO | Oct 6 – Nov 9, 2026 | Celo Devs |
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

> **Celo Builder Fund source:** the archived program page (https://web.archive.org/web/20260715164457/https://www.celopg.eco/programs/celo-builder-fund) shows the terms above. The live page returns 404 and celopg.eco no longer lists programs (checked 2026-11-03), so do not point builders to it. Verda Ventures runs a separate MiniPay Fund (see `minipay-guide.md`).

---

## Grant Matchmaking Guide

> **Before you apply:** add [attribution tags](attribution-tags.md) to your transactions as early as possible. Celo tracks ecosystem impact via ERC-8021 attribution data and will use it for future reward distribution — programs that reward on-chain usage can only credit what's attributable.

| Building… | Recommended Program |
|-----------|---------------------|
| Project with real traction (5K+ daily transactions), such as MiniPay apps | **Prezenti Anchor Pool (S3)**: $25,000+ USDm, applications open until Dec 29, 2026 |
| AI agents or agent-economy infrastructure | **Prezenti Frontier Pool (S3)**: $15,000+ USDm, applications open until Dec 29, 2026 |

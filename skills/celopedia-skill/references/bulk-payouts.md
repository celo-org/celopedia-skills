# Bulk Payouts & Mass Distribution on Celo

> Sources: on-chain verification via forno.celo.org (chain 42220), docs.celo.org,
> safe-config.safe.global, specs.celo.org
> Every address below was confirmed to hold bytecode on Celo Mainnet on 2026-09-24.
> For live gas costs, recompute from the current base fee and CELO price — the dollar
> figures here are a snapshot.
> Last updated: 2026-09-24

Paying many recipients at once — creator rewards, referral payouts, payroll, airdrops,
cashback. Celo has **no first-party "blast sender" product**, but the standard EVM
batch-distribution contracts are all deployed at their canonical addresses, and the
economics are unusually good: at measured mainnet gas, **1,000 stablecoin payouts cost
about $1.10 in total network fees**.

The hard part is never the sending. It's recipient addressing, idempotency, and sybil
resistance.

---

## 1. Pick the right tool

| Situation | Use | Why |
| --- | --- | --- |
| One-off, recipients already have addresses, treasury is a single EOA | **Disperse** contract, called directly | One approval + one call per chunk. No deploy, no infra. |
| Treasury should require multiple signers | **Safe** + CSV Airdrop app (or Transaction Builder) | Batches into one Safe tx via MultiSendCallOnly; reviewers see the full list before signing. |
| Recurring, automated, from a backend | **Backend queue with parallel nonces** (e.g. thirdweb Engine) or your own distributor contract | Survives restarts, retries, and nonce gaps. Needed once payouts are a scheduled job, not a person clicking. |
| Recipients may never claim, and you want the funds back | **Merkle claim distributor** (pull, not push) | You publish a root; recipients claim. Unclaimed funds stay yours and gas shifts to the claimer. |
| Payment should accrue continuously, not monthly | **Superfluid** distribution pools | Update the pool once; value streams per second. Removes the batch entirely. |
| Recipients are identified by phone number, not address | **ODIS / SocialConnect** lookup first, then any of the above | See `odis-socialconnect.md`. Resolve to addresses before you build the batch. |
| Recipients need money in a bank account, not a wallet | Off-ramp rails — see `stablecoin-orchestration.md` | Out of scope for this file; that's a fiat problem, not a batching one. |

**Batching from an EOA without a helper contract**: EIP-7702 is live on Celo Mainnet
(Isthmus hardfork, activated 2025-07-09 at block 40,172,442). An EOA can delegate to a
batch-call implementation and perform N transfers in a single transaction with
`msg.sender` preserved. Useful when you don't want an approval to a third-party contract.

---

## 2. Verified batch-distribution contracts (Mainnet, chain 42220)

| Contract | Address | Notes |
| --- | --- | --- |
| Disperse | `0xD152f549545093347A162Dce210e7293f1452150` | `disperseEther(address[],uint256[])` `0xe63d38ed` · `disperseToken(address[],uint256[])` `0xc73a2d60` · `disperseTokenSimple(...)` `0x51ba162c` |
| Multicall3 | `0xcA11bde05977b3631167028862bE2a173976CA11` | Reads and aggregation only — **not usable for token payouts**, see §4 |
| Safe singleton 1.4.1 | `0x41675C099F32341bf84BFc5382aF534df5C7461a` | |
| Safe singleton 1.3.0 (L2) | `0x3E5c63644E683549055b9Be8653de26E0B4CD36E` | |
| SafeProxyFactory 1.3.0 | `0xa6B71E26C5e0845f74c812102Ca7114b6a896AB2` | |
| MultiSend 1.3.0 | `0xA238CBeb142c10Ef7Ad8442C6D1f9E89e07e7761` | `delegatecall` variant |
| MultiSendCallOnly 1.3.0 | `0x40A2aCCbd92BCA938b02010E17A5b8929b49130D` | What the CSV Airdrop app uses |
| MultiSendCallOnly 1.4.1 | `0x9641d764fc13c8B624c04430C7356C1C7C8102e2` | |
| Permit2 | `0x000000000022D473030F116dDEE9F6B43aC78BA3` | Signature-based approvals, avoids a standing allowance |
| Superfluid Host | `0xA4Ff07cF81C02CFD356184879D953970cA957585` | |
| Superfluid CFAv1 | `0x9d369e78e1a682cE0F8d9aD849BeA4FE1c3bD3Ad` | |

**Safe supports Celo officially.** `safe-config.safe.global/api/v1/chains/42220/` returns
`chainName: "Celo"`, `l2: true`, `isTestnet: false`. UI at <https://safe.celo.org>.

---

## 3. Gas and batch sizing

Measured on Mainnet via `eth_estimateGas`, not estimated from a table:

| Operation | Gas |
| --- | --- |
| USDm (cUSD) `transfer` to an address with **no prior balance** (cold storage slot) | **57,443** |
| USDm (cUSD) `transfer` to an **existing holder** (warm slot) | **35,326** |

Network conditions at time of measurement: block gas limit **30,000,000**, base fee
**200 gwei**, gas price **202.5 gwei**, CELO **$0.094**.

**Per payout**: 57,443 × 202.5 gwei ≈ 0.0116 CELO ≈ **$0.0011**

**Batch sizing**: 30,000,000 ÷ 57,443 ≈ **522 recipients per transaction** is the
theoretical ceiling. Chunk at **250–400** to leave headroom for the warm/cold mix, the
Disperse loop overhead, and block-fullness variation. Never size a batch so close to the
limit that a colder-than-expected recipient set pushes it over — the whole transaction
reverts and you pay for the failure.

**Worked example — 1,000 creators at $5/month:**

| | |
| --- | --- |
| Disbursed | $5,000 |
| Transactions | 3 (chunks of ~350) |
| Total gas | ~57.4M |
| **Network fees** | **~$1.10** — about 0.02% of the amount disbursed |

First-time recipients cost the most (cold slot); the same list next month costs ~40% less
per recipient because the balance slots are already warm.

---

## 4. Five things that silently go wrong

**1. Multicall3 cannot send token payouts from an EOA.**
This is the most common wrong answer to "how do I batch ERC-20 sends". Inside a
Multicall3 batch, `msg.sender` is *Multicall3*, so a batched `transfer` moves
Multicall3's balance — which is zero — not yours. Multicall3 is for batching **reads**.
Disperse works because it uses `transferFrom(msg.sender, recipient, amount)` behind a
single approval, so the tokens move from the caller.

**2. disperse.app's hosted UI does not appear to offer Celo.**
The contract is deployed and fully functional, but the hosted frontend's bundle
references chain IDs 1, 10, 100, 137, 8453 and 42161, with no occurrence of 42220. Verify
by connecting; if Celo isn't in the network list, call the contract directly with viem or
`cast`, or use the Safe Transaction Builder. **The contract being deployed and the UI
supporting the chain are two different things** — check both before telling a builder to
"just use disperse.app".

**3. Decimals.** USDm (cUSD) is 18, USDC and USDT are 6, and some Celo tokens use other
values entirely (IDRX is 2). A payout script that hardcodes one shape over- or under-pays
by orders of magnitude, silently. Read decimals from the token, per `contracts.md`.

**4. Use `feeCurrency` so the treasury holds one asset.**
With CIP-64 fee abstraction the payout wallet pays gas in the same stablecoin it's
disbursing, so it never needs a CELO balance topped up out-of-band. USDC and USDT require
the **adapter** address in the `feeCurrency` field, not the token address; USDm/EURm/BRLm
use their token address. Canonical table: `builder-guide.md` → *Allowed Fee Currencies
(Mainnet)*. **viem supports `feeCurrency` natively; ethers.js and web3.js do not.**

**5. Idempotency — a retry must not double-pay.**
A monthly run that times out mid-batch and restarts is the classic way to pay someone
twice. Key each disbursement on `(period, recipientId)`, persist the tx hash **before**
broadcasting, and make the resume path check on-chain state rather than trusting local
progress. If payouts run from a contract, track a per-period claimed bitmap.

---

## 5. Anti-sybil — you are funding a farming target

A fixed per-head reward paid on a recurring schedule is exactly the shape attackers look
for. At $5 per recipient per month, 200 fake accounts is $1,000/month, and creating a
wallet is free.

Ranked by effectiveness against friction added:

| Mitigation | Effectiveness | Friction |
| --- | --- | --- |
| Cap total spend per period at the treasury level (circuit breaker) | Medium | None — do this first |
| Require a meaningful qualifying action, not just existence | High | Low |
| Hold rewards in escrow with a clawback window before release | High | Medium |
| Phone verification via ODIS (`odis-socialconnect.md`) | High | Medium — excludes users without phones |
| ZK proof-of-personhood via Self (`self-agent-id.md`) | Very high | High — expect drop-off |
| Manual review of outlier patterns | Medium | High operational cost |

**Recommended starting stack**: a hard per-period treasury cap, plus a qualifying action,
plus a short escrow window. That blocks the large majority of attempts without putting
friction on genuine recipients. Fuller treatment, including the escrow and cap patterns:
`growth-referrals.md` → *Anti-sybil*.

Note that reward programs funded by third-party revenue have a second failure mode:
if the reward per head is fixed but the funding pool is variable, a sybil wave doesn't
just cost money, it dilutes real recipients. Prefer distributing a **share of a fixed
pool** over a **fixed amount per head** when the funding source can fluctuate.

---

## 6. Ship-it checklist

- [ ] Recipient list resolved to addresses and de-duplicated
- [ ] Token decimals read from the contract, not assumed
- [ ] Amounts summed and reconciled against the intended total before broadcast
- [ ] Chunked to 250–400 recipients per transaction
- [ ] `feeCurrency` set so gas is paid in the payout stablecoin
- [ ] Dry run on Celo Sepolia (chain ID `11142220`) with the real list shape
- [ ] Idempotency key per `(period, recipient)`; tx hash persisted before broadcast
- [ ] Treasury spend cap enforced independently of the payout logic
- [ ] ERC-8021 attribution suffix added — see `attribution-tags.md`

---

## See also

- `contracts.md` → *Batch Distribution & Utility Contracts*, token addresses and decimals
- `builder-guide.md` → fee currency table and adapter addresses
- `growth-referrals.md` → anti-sybil patterns, on-chain payout attribution
- `odis-socialconnect.md` → phone number → address resolution
- `self-agent-id.md` → proof-of-personhood for reward eligibility
- `stablecoin-orchestration.md` → when recipients need fiat in a bank account instead
- `minipay-guide.md` / `minipay-requirements.md` → constraints if the payout surface is a
  Mini App (no arbitrary withdrawal addresses, no address display)

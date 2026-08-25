# Migrating a dApp to Celo from Another Chain

> Sources: docs.celo.org, specs.celo.org/token_duality.html, docs.lisk.com, ethereum-lists/chains
> Verified on-chain against `forno.celo.org` where noted.

How to move an existing EVM app to Celo from another L2 — Lisk, Base, Optimism, Mode, Ink, Unichain, Soneium, Zora, Fraxtal. Covers auditing the repo, mapping tokens and protocols, the two semantic changes that silently break working code, and a testnet verification path.

> **Not to be confused with Celo's own L1→L2 migration** (March 26, 2025, block 31,056,500). That is a historical fact about the chain. This file is about moving *your app* onto it. See `builder-guide.md` → _L2 Migration Context_ for the former.

---

## Are you moving, or expanding?

Ask this first — it changes the plan, and most teams have not decided.

| | **Full move** | **Multichain (stay + add Celo)** |
|---|---|---|
| Source-chain contracts | deprecate, migrate liquidity off | keep running |
| Token | move canonical supply | needs a bridge/mint story across both |
| Users | one-time migration comms | audience split; per-chain UX |
| Effort | higher up front, one chain to maintain | lower up front, two chains forever |

Most teams arriving from another OP Stack L2 want the second. Don't assume the first.

---

## Chain delta

| | Source (typical OP Stack L2) | **Lisk** | **Celo** |
|---|---|---|---|
| Chain ID | varies | `1135` / `4202` Sepolia | `42220` / `11142220` Sepolia |
| RPC | varies | `rpc.api.lisk.com` | `forno.celo.org` |
| Explorer | Blockscout | `blockscout.lisk.com` | Celoscan + Blockscout |
| **Gas token** | **ETH** | **ETH** | **CELO** — native *and* ERC-20 |
| **Fee abstraction** | none | none | **CIP-64** — gas in USDC/USDT/USDm |
| Block time | ~2s | ~2s (per lisk.com; not stated in docs) | ~1s |
| DA | Ethereum blobs | Ethereum blobs | EigenDA v2 |
| Fault proofs | OP standard | OP standard | ZK via Succinct SP1 |
| Stablecoins | bridged | USDC.e, USDT, USDt0, EURC.e — all bridged | native USDC/USDT + 15+ Mento local currencies |

Verified source chain IDs and gas tokens (`ethereum-lists/chains`):

| Chain | ID | Gas token |
|---|---|---|
| Lisk | 1135 | ETH |
| Lisk Sepolia | 4202 | ETH |
| Base | 8453 | ETH |
| OP Mainnet | 10 | ETH |
| Mode | 34443 | ETH |
| Ink | 57073 | ETH |
| Unichain | 130 | ETH |
| Soneium | 1868 | ETH |
| Zora | 7777777 | ETH |
| **Fraxtal** | 252 | **FRAX** — not ETH |

Both chains are EVM-equivalent OP Stack rollups, so **contract bytecode ports unchanged**. The work is configuration, address mapping, and the two semantic changes in **Phase 3**.

---

## Phase 1 — Audit the repo

Run these and build a findings table before changing anything.

```bash
# Distinctive chain IDs — safe to grep bare, but still review every hit by hand
rg -n '\b(1135|4202|8453|34443|57073|1868|7777777)\b' --type-add 'cfg:*.{ts,js,json,toml,sol,env,yaml,yml}' -tcfg

# Noisy chain IDs (OP Mainnet 10, Unichain 130, Fraxtal 252) — bare digits match
# far too much, so match only in a chain-config position
rg -n --pcre2 '(?i)(chain_?id|chain)\W{0,3}(10|130|252)\b'

# RPC and explorer hosts
rg -n 'api\.lisk\.com|blockscout\.lisk\.com|\.gateway\.tenderly|drpc\.org|alchemy|infura'

# Chain object imports
rg -n "from ['\"]viem/chains['\"]|\b(lisk|liskSepolia|base|optimism|mode|ink|unichain|soneium)\b" -g '*.ts' -g '*.tsx'

# Native-gas assumptions
rg -n 'parseEther|formatEther|msg\.value|nativeCurrency|\bWETH\b|deposit\{value'

# User-facing "ETH"
rg -n '"[^"]*\bETH\b[^"]*"' -g '*.tsx' -g '*.ts'

# Toolchain config
rg -n 'rpc_endpoints|etherscan|verify|chainId' foundry.toml hardhat.config.* 2>/dev/null
```

> **Chain IDs are the one pattern that produces false positives.** `1135` is also a plausible token amount, array length, or block number — `4202` likewise. Never bulk-replace a numeric chain ID; confirm each hit sits in a chain-config position first. `10`, `130` and `252` are so collision-prone as bare digits that the second pattern above deliberately scopes them to `chainId:`-style assignments — at the cost of missing one written any other way, which is the right trade.

Record findings as `file:line → what it is → what it becomes`, then confirm with the user before editing.

### Lisk token addresses to grep for

All verified on-chain against `rpc.api.lisk.com` (symbol + decimals):

| Token | Lisk address | Decimals |
|---|---|---|
| USDC.e | `0xF242275d3a6527d877f2c927a82D9b057609cc71` | 6 |
| USDT | `0x05D032ac25d322df992303dCa074EE7392C117b9` | 6 |
| USDt0 | `0x43F2376D5D03553aE72F4A8093bbe9de4336EB08` | 6 |
| EURC.e | `0xe12cEFaAD61e551691BFa5cDA36e5dE051778C65` | 6 |
| LSK | `0xac485391EB2d7D88253a7F1eF18C37f4242D1A24` | 18 |
| WBTC | `0x03C7054BCB39f7b2e5B2c7AcB37583e32D70Cfa3` | 8 |
| wstETH | `0x76D8de471F54aAA87784119c60Df1bbFc852C415` | 18 |

---

## Phase 2 — Map tokens and protocols

### Tokens

| From (Lisk) | To (Celo) | Notes |
|---|---|---|
| USDC.e (bridged) | **USDC** `0xcebA9300f2b948710d2653dD7B07f33A8B32118C` | native Circle issuance, 6 decimals |
| USDT | **USDT** `0x48065fbBE25f71C9282ddf5e1cD6D6A887483D5e` | 6 decimals |
| USDt0 | USDC or USDT above | no Celo equivalent; pick a canonical stable |
| EURC.e (6 dec) | **EURm** `0xD8763CBa276a3738E6DE85b4b3bF5FDed6D6cA73` | Mento euro, **18 decimals** — verified both ends; not a like-for-like swap |
| WETH | **WETH** `0xD221812de1BD094f35587EE8E174B07B6167D9Af` | ⚠️ see **Phase 3.2** — **not** a wrapper, has no `deposit()` |
| LSK | — | no Celo equivalent; bridge or drop |
| WBTC / wstETH | — | **not in `contracts.md`** — verify on Celoscan before use; do not assume an address |

> **Decimals change silently.** EURC.e is 6 decimals; EURm is 18. Any `parseUnits(x, 6)` that survives the swap sends a value off by 10¹². Same trap in reverse for USDm (18) vs USDC (6). See `builder-guide.md` → _Token Decimal Mismatch_.

Full address tables: `contracts.md`. **Never introduce an address that isn't in there** — if a token is missing, say so rather than guess.

### Protocols

| From | To (Celo) | Portability |
|---|---|---|
| Velodrome | **Velodrome V3** | same protocol, both chains — near drop-in |
| Oku / Uniswap v3 | **Uniswap V3/V4** | same interfaces, new pool addresses |
| Fluid | **Aave V3**, **Morpho V1**, or **Feather** | ⚠️ no Fluid on Celo — different interfaces, needs a rewrite |
| — | **Mento** | Celo-only: local-currency stablecoins |

When a dependency has no Celo counterpart, say so plainly and give the options: bridge the asset, substitute a different protocol (with the interface delta spelled out), or flag it as a blocker. **Never invent a mapping.** See `ecosystem.md` and `defi-protocols.md`.

Bridges: Superbridge (`superbridge.app/celo`), Wormhole, Squid, AllBridge — `ecosystem.md` → _Bridges_.

---

## Phase 3 — The two semantic changes

Everything above is configuration. This section is where working code breaks **silently**. Read it before editing contracts.

### 3.1 Gas token: ETH → CELO

Users need CELO instead of ETH — or, better, nothing at all:

- **Minimal path**: users hold CELO for gas. App otherwise unchanged.
- **Recommended path**: adopt **CIP-64 fee abstraction** so users pay gas in USDC/USDT/USDm and never touch CELO. This is the single biggest UX gain from the move and usually the reason to make it. Full mechanics in `builder-guide.md` → _Fee Abstraction (CIP-64)_.

Carry these caveats:

- `feeCurrency` is a distinct transaction type — some libraries and tooling don't support it.
- **Use adapter addresses for USDC/USDT** (6→18 decimal adapters), token addresses for USDm/EURm/BRLm. Passing the token address for USDC/USDT fails. Table in `network-info.md` → _Fee-Accepted Tokens_.
- MiniPay is **legacy-tx only** — never set `maxFeePerGas`/`maxPriorityFeePerGas` (`builder-guide.md` → _MiniPay Only Supports Legacy Transactions_).
- Gas estimation differs when a fee currency is set — `builder-guide.md` → _Gas Estimation with Fee Currency_.
- Any contract refunding gas to `msg.sender` needs its assumptions rechecked.

### 3.2 CELO token duality — the dangerous one

On Celo, **CELO is simultaneously the native gas token and an ERC-20** at `0x471EcE3750Da237f93B8E339c536989b8978a438`. Per `specs.celo.org/token_duality.html`, the ERC-20 `transfer`/`transferFrom` do **not** write contract storage — they perform a **native** transfer through a precompile at address 253 (`0xfd`), callable only by the CELO contract, at a fixed 9000 gas. `balanceOf(addr)` returns the native balance directly.

Verified live on mainnet: `balanceOf(0xD533Ca…)` and that account's native balance return the **identical** value. There is one balance, reachable two ways.

Five things that break on arrival from an ETH-gas chain:

| # | Break | Consequence |
|---|---|---|
| 1 | **`WETH.deposit{value:}()` reverts** | Celo's WETH (`0xD221812d…`, *"Wrapped Ether (Celo native bridge)"*) is **bridged ETH, not a wrapper** — verified on-chain to have **no `deposit()` and no `withdraw()`**. Ported wrap-before-swap logic compiles, points at a real address, and **reverts at runtime**. On Celo you never wrap: pass the CELO ERC-20 address directly. |
| 2 | **Double-counting** | `address(this).balance + IERC20(WETH).balanceOf(address(this))` is correct on Lisk and a **2× overcount** on Celo if WETH is swapped for the CELO ERC-20. No revert — just wrong numbers in treasury math, TVL displays, and accounting. |
| 3 | **`receive()` never fires on the ERC-20 path** | A native transfer executes **no code** on the recipient. A contract crediting deposits in `receive()`/`fallback()` **silently no-ops** when a user pays via `IERC20(CELO).transfer()` — funds arrive in the balance, the user is never credited. The most dangerous item on this page. |
| 4 | **Reentrancy assumptions invert** | A CELO ERC-20 transfer hands control to *nobody*, so a `ReentrancyGuard` around one is dead weight. Conversely, code assuming "ERC-20 transfer = cheap storage write" now pays a flat 9000 gas per transfer — audit batch-payout loops, which get materially more expensive. |
| 5 | **An approval exposes the user's gas money** | `approve()`/`allowance()` are implemented on the CELO ERC-20 (verified live), and `balanceOf` *is* the native balance. So granting an unlimited CELO allowance lets a spender move the balance the user needs to pay gas — **a drain surface that cannot exist on an ETH-gas chain.** Treat unlimited CELO approvals as a security review item, not a UX convenience. |

**Pick the path that matches the recipient.** If the target is `payable` and reads `msg.value`, use the native path. If it takes `uint256 amount` behind an allowance, use the ERC-20 path. When unsure, read the contract on Celoscan. Worked example: `builder-guide.md` → _Sending CELO — common failure & fix_.

### 3.3 Foundry fork tests will lie to you about §3.2

Foundry does not simulate the `0xfd` precompile, and the failure mode is the worst kind: **the transfer reports success and moves nothing.**

Measured on `anvil --fork-url https://forno.celo.org`:

```
$ cast send $CELO "transfer(address,uint256)" $B 1000000000000000000
  status 0x1        <- SUCCESS
  gasUsed 32908

recipient native balance:  10000000000000000000000  (unchanged)
recipient balanceOf():     10000000000000000000000  (unchanged)
```

No revert. A non-zero gas charge. A `true` return. And **zero tokens moved.** Any test that asserts "the call didn't revert" passes; only a test that asserts the *balance delta* catches it. A ported suite can go fully green against a fork while mainnet behaves entirely differently.

Fixes: `vm.deal(addr, amount)` for native, `deal(CELO_ADDRESS, user, amount)` for ERC-20 (`builder-guide.md` → _Foundry Fork Testing & Token Duality_). And always assert **balance deltas**, never just success. Anything touching duality must be confirmed on a real testnet (Phase 5) — fork-green is not verification.

---

## Phase 4 — Apply the edits

Ordered. Confirm each group with the user before writing.

1. **Configs** — `foundry.toml`, `hardhat.config.ts`, wagmi/viem client. Templates in `dev-templates.md`; don't hand-roll.
2. **Chain object** — `lisk` → `celo`, `liskSepolia` → `celoSepolia` from `viem/chains`.
3. **Token constants** — per the Phase 2 map. Re-check every decimal.
4. **Gas path** — minimal or CIP-64 (§3.1).
5. **Duality fixes** (§3.2) — remove wrap steps, fix double-counted balances, add an ERC-20 deposit path alongside `receive()`, re-audit approval scopes and payout-loop gas.
6. **UI strings** — "ETH" → "CELO". If targeting MiniPay, apply the banned-terms rules in `minipay-requirements.md` §3 instead ("Gas fee" → "Network fee", etc.).
7. **Verification** — Celoscan or Blockscout, per `builder-guide.md` → _Contract Verification_.

---

## Phase 5 — Verify on testnet

Celo Sepolia (`11142220`), RPC `https://forno.celo-sepolia.celo-testnet.org`, faucets in `network-info.md` → _Testnet Faucets_.

Deploy, verify, then assert the things a fork cannot tell you:

1. A tx with `feeCurrency` set to a stablecoin adapter debits gas **in the token, not CELO**.
2. A contract with a flag-setting `receive()` fires on the native path and **not** on `IERC20(CELO).transfer()` (§3.2 break 3).
3. Payout loops still fit the block gas limit at 9000 gas per CELO transfer (§3.2 break 4).
4. Every swapped token address returns the expected `symbol()` and `decimals()`.

---

## What to adopt once it lands

Moving is the floor. These are the reasons to stay:

- **Fee abstraction** — users transact holding only stablecoins. `builder-guide.md`.
- **MiniPay** — 16M+ wallets, distribution to emerging markets. `minipay-guide.md`, and `minipay-requirements.md` for the listing checklist.
- **Mento local stablecoins** — 15+ local currencies (KESm, NGNm, GHSm, ZARm, COPm, PHPm…). Nothing equivalent on Lisk. `defi-protocols.md`.
- **Grants** — `grants-funding.md`, and always check `celopg.eco/programs` live.

---

## Remaining gotchas

- **Block time halves, 2s → 1s.** Any code treating block count as elapsed time is now **2× fast**. Audit vesting schedules, timelocks, TWAPs, cooldowns, and `block.number` deadlines. Prefer `block.timestamp`.
- **`eth_getLogs` caps at ~50,000 blocks** — indexers must paginate. `network-info.md` → _RPC Limits & Gotchas_.
- **Subgraph coverage lags** other chains — verify freshness before depending on one. `defi-protocols.md`.
- **CELO is hidden in MiniPay** — never display or require it in a Mini App.

---

## Adding another source chain

Keep this file general:

1. Add a column to the **Chain delta** table — chain ID, RPC, explorer, gas token (verify against `ethereum-lists/chains`; **don't assume ETH** — Fraxtal uses FRAX).
2. Add the chain's token addresses to the Phase 1 grep table from its own docs.
3. Add its protocol set to the Phase 2 map, marking anything with no Celo counterpart.
4. Phase 3 is chain-independent — every ETH-gas chain hits the same duality breaks.

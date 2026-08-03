# Celo Attribution Tags (ERC-8021)

> Source: https://github.com/celo-org/attribution-tags (BUILDERS.md + sdk/README.md), npm `@celo/attribution-tags`
> Last updated: 2026-07-02.

Attribution tags let Celo trace every transaction back to the app that produced it. **Every project building on Celo should add them as early as possible — ideally before the first mainnet transaction.** Celo uses the aggregated data to track ecosystem impact, and it will feed **future reward distribution**. Untagged transactions are unattributed history: they cannot be claimed retroactively.

---

## What & Why

ERC-8021 is a standard for appending a small attribution suffix to a transaction's calldata. The EVM discards trailing bytes, so the suffix is **invisible to the contract being called** — adding it never changes execution semantics. It just makes the transaction identifiable as having come through your app.

- **Impact tracking** — Celo's attribution dashboard (Dune-based) surfaces tagged transactions grouped by app code
- **Future rewards** — reward distribution programs will use this attribution data; tagging early maximizes claimable history
- **Zero risk** — no execution change, no gas-meaningful overhead, one small suffix per transaction

**Who should add it:** everyone sending transactions on Celo — MiniPay Mini Apps, Proof of Ship cohort projects, DeFi frontends, AI agents, any dApp.

---

## Quick Start

```bash
npm install @celo/attribution-tags viem
```

`viem` is an optional peer dep — only needed for `verifyTx` (decoding from a tx hash).

### Option A — Hostname-derived code (zero registration; MiniPay default)

The SDK derives a deterministic per-app code from your hostname. Same hostname → same code, every time. No backend, no key, no form:

```ts
import { toDataSuffix, codeFromHostname } from "@celo/attribution-tags";

const tag = toDataSuffix(codeFromHostname(location.hostname));

await wallet.sendTransaction({ to, value, data: tag });
```

`codeFromHostname` lowercases and strips a leading `www.` (SHA-256, first 6 bytes → `celo_` + 12 hex chars). Subdomains stay distinct — `app.example.com` ≠ `example.com` — so apps on shared hosts like `*.vercel.app` don't collide.

### Option B — Issued or custom code

Issued through Proof of Ship onboarding, or pick your own (`[a-z0-9_]`, 1–32 chars):

```ts
import { toDataSuffix } from "@celo/attribution-tags";

const tag = toDataSuffix("celo_b7k3p9da"); // issued code — or a custom one, e.g. toDataSuffix("myapp")
```

Custom codes tag transactions immediately, but getting them **credited** on the attribution dashboard is a registry-layer step — register via the repo's contact. For local dev, hardcode `celo_test1234`.

---

## Integration Patterns

### Contract calls (viem) — concatenate after the calldata

```ts
import { encodeFunctionData, concat } from "viem";

const callData = encodeFunctionData({ abi, functionName: "transfer", args });
const taggedData = concat([callData, tag]);

await wallet.sendTransaction({ to: tokenAddress, data: taggedData });
```

### wagmi — pass `dataSuffix`

```ts
const { writeContract } = useWriteContract();

writeContract({
  address, abi,
  functionName: "transfer",
  args,
  dataSuffix: tag,
});
```

### SSR frameworks (Next.js, Remix, SvelteKit)

`window.location.hostname` is browser-only. Never derive the tag at module top level — even in `"use client"` files, which still execute on the server during SSR. Guard it:

```ts
// lib/attribution-tag.ts
import { toDataSuffix, codeFromHostname } from "@celo/attribution-tags";
import type { Hex } from "viem";

let cached: Hex | null = null;

export function getAttributionSuffix(): Hex | undefined {
  if (typeof window === "undefined") return undefined;
  if (cached) return cached;
  try {
    cached = toDataSuffix(codeFromHostname(window.location.hostname)) as Hex;
    return cached;
  } catch {
    return undefined;
  }
}
```

Or derive inside an event handler / `useEffect` — those only run in the browser.

---

## Verify It Worked

Always confirm the suffix is actually on-chain — some ERC-4337 bundlers and meta-tx relayers rewrite calldata and strip trailing bytes:

```ts
import { verifyTx } from "@celo/attribution-tags";
import { createPublicClient, http } from "viem";
import { celo } from "viem/chains";

const client = createPublicClient({ chain: celo, transport: http() });

const result = await verifyTx({ client, hash: "0x..." });
// → { codes: ["celo_b7k3p9da"], schemaId: 0 } or null
```

`verifyTx` never throws — `null` means the tag didn't make it onto the wire. Most common causes: you set `data: code` instead of `data: toDataSuffix(code)`, or your relayer dropped the suffix.

Offline (no RPC): `fromDataSuffix(rawCalldata)` decodes raw calldata the same way.

---

## Rules & Gotchas

1. **Only add your own code — never platform codes.** Codes like `minipay` or `proofofship` are added by the platform itself (wallet/cohort layer). If your app adds `minipay`, every transaction from a plain browser falsely claims to be a MiniPay transaction and pollutes the attribution data.
2. **The suffix goes *after* your contract's expected calldata**, never inside it. The contract sees only its real arguments.
3. **Code charset is `[a-z0-9_]`, 1–32 chars.** The SDK rejects uppercase, spaces, and commas at encode time.
4. **The suffix is metadata for off-chain readers**, not for contract logic — it doesn't survive into contract execution.
5. **Celo-only** — the implementation targets Celo Mainnet (42220) and Celo Sepolia (11142220), following the ERC-8021 standard.

### API surface

| Export | Returns |
|--------|---------|
| `toDataSuffix(code \| codes[])` | encoded suffix (`Hex`) |
| `codeFromHostname(hostname)` | `"celo_" + 12 hex chars` |
| `fromDataSuffix(data)` | `{ codes, schemaId }` or `null` |
| `verifyTx({ client, hash })` | `{ codes, schemaId }` or `null` (never throws) |
| `ERC_8021_MARKER` | `0x80218021802180218021802180218021` |

Wire format (Schema 0): `[code:N][length:1][schema:1][marker:16]`.

---

## See Also

- `builder-guide.md` — Recommended Development Flow (add the tag before you ship)
- `grants-funding.md` — reward programs that will use attribution data
- Repo: https://github.com/celo-org/attribution-tags — `BUILDERS.md` (this guide's source), `INDEXERS.md` (Dune models / parsers), `sdk/README.md` (full API)
- npm: https://www.npmjs.com/package/@celo/attribution-tags

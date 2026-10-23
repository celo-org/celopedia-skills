# x402 Seller Discoverability on Celo

> Source: x402 `bazaar` extension spec (github.com/x402-foundation/x402, `specs/extensions/bazaar.md`), `@x402/extensions` 2.27, `@x402/evm` 2.28.0, Coinbase seller docs (`docs.cdp.coinbase.com/x402/seller/get-discovered`, `/x402/network-support`), agent402.tools (github.com/MikeyPetrillo/Agent402), x402scan (github.com/Merit-Systems/x402scan), docs.celo.org/build/agents/x402-get-discovered
> Last updated: 2026-10-23. Index entry rules change without notice; re-check before quoting.

A working 402 endpoint on Celo is invisible until (1) its 402 response describes the endpoint in a machine-readable way and (2) it is listed where agents look. There is no single index. Use this reference when a builder asks "how do agents find my paid API?" or "how do I get listed?".

---

## The two halves

1. **Self-description** — the x402 `bazaar` extension embeds method, example input, input JSON schema, and example output in the 402. Any facilitator or crawler that understands the extension can catalog the endpoint from the 402 alone.
2. **Registration** — each index has its own entry rule. The table below is the current state.

| Index | Entry | Requirement / caveat |
|-------|-------|----------------------|
| **agent402.tools** | 1. Publish a service manifest at `/.well-known/x402` on a stable HTTPS origin. 2. `POST https://agent402.tools/api/index/register` with `{"origin":"https://api.you.com"}` | Free, no account. Each crawl fetches `/.well-known/x402` plus `openapi.json`; without a manifest an origin is accepted only if it is in Coinbase's Bazaar or its openapi carries a payment extension, so a Celo-only origin needs the manifest. Re-crawled every 30 min; ranks by health. Lists Celo. |
| **Coinbase x402 discovery (Bazaar)** | Indexed after a paid call settles through **Coinbase's** facilitator. Only the CDP SDK's `createX402Server` (TypeScript) declares discovery automatically; with the bare `@x402/*` packages (as in the snippet below) or Python, register the Bazaar extension and declare it per route yourself | Coinbase's facilitator settles on Base, Polygon, Arbitrum, Monad, World, Solana (testnets: Base Sepolia, World Sepolia, Solana Devnet) — **not on Celo**. Whether a Celo offer listed next to a settled one is shown is not documented. Listings with no settlement for 30 days are removed. |
| **x402scan** | Web form at `https://www.x402scan.com/resources/register`, or the API (`POST /api/x402/registry/register`, `/register-origin`, SIWX-authenticated) | Added if the URL returns a valid challenge; accepts **Base and Solana** resources only (`SUPPORTED_CHAINS = [BASE, SOLANA]`), so Celo-only endpoints are rejected. |
| **8004scan** | Register an ERC-8004 identity on Celo; list endpoints under `services`, set `x402Support: true` in the registration file | Registry addresses and flow: `ai-agents.md` → ERC-8004, docs `/build/agents/8004`. |
| **Buy catalog (usebuy.ai)** | Listing request via the buy-skill issue form `https://github.com/celo-org/buy-skill/issues/new/choose` | Curated; needs origin, description, price, networks, tokens. |

Key consequence for advice: an endpoint that accepts only Celo cannot appear in Coinbase's index or on x402scan today. Recommend **agent402.tools + ERC-8004 + a self-describing 402** as the baseline. Add a second offer on a network those indexes support (for example Base via Coinbase's facilitator, alongside Celo via `api.x402.celo.org`) only if the builder specifically needs the Coinbase or x402scan surfaces, and don't promise that the Celo offer will be displayed there.

---

## Self-describing 402 (verified 2026-09-28 against api.x402.celo.org)

```ts
// Celo mainnet. npm i express @x402/express @x402/core @x402/evm @x402/extensions
import express from "express";
import { paymentMiddleware, x402ResourceServer } from "@x402/express";
import { HTTPFacilitatorClient } from "@x402/core/server";
import { ExactEvmScheme } from "@x402/evm/exact/server";
import { bazaarResourceServerExtension, declareDiscoveryExtension } from "@x402/extensions/bazaar";

const facilitator = new HTTPFacilitatorClient({
  url: "https://api.x402.celo.org",
  createAuthHeaders: async () => {
    const h = { "X-API-Key": process.env.X402_API_KEY! };
    return { verify: h, settle: h, supported: h };
  },
});
const server = new x402ResourceServer(facilitator)
  .register("eip155:42220", new ExactEvmScheme())
  .registerExtension(bazaarResourceServerExtension);

const routes = {
  "GET /weather": {
    accepts: {
      scheme: "exact", network: "eip155:42220", payTo: "0xSellerPayout",
      price: { amount: "10000", asset: "0xcebA9300f2b948710d2653dD7B07f33A8B32118C", extra: { name: "USDC", version: "2" } },
    },
    description: "Current weather for a city",   // ≤ 500 chars, written for an agent deciding whether to call
    mimeType: "application/json",
    extensions: declareDiscoveryExtension({
      method: "GET",
      input: { city: "Lagos" },
      inputSchema: { properties: { city: { type: "string" } }, required: ["city"] },
      output: { example: { city: "Lagos", tempC: 31, sky: "haze" } },
    }),
  },
};
const app = express();
app.use(paymentMiddleware(routes, server));
app.get("/weather", (req, res) => res.json({ city: req.query.city, tempC: 31, sky: "haze" }));
app.listen(3000);
```

Resulting 402 (abridged): `resource.description`, `accepts[]`, and `extensions.bazaar.info = { input: { type: "http", method: "GET", queryParams: { city: "Lagos" } }, output: { type: "json", example: {...} } }` plus a generated `schema`. For `POST` routes pass `method: "POST"`, `bodyType: "json"`, and the example body as `input`.

Gotchas:
- No `extensions` block in the 402 → `registerExtension(bazaarResourceServerExtension)` missing, or the route has no `extensions` entry.
- The explicit `price` object is optional for USDC/USDT/USAT on Celo (`@x402/evm`'s default-asset table has them); pass it to pin the asset, as above (see `ai-agents.md` → x402 gotchas).
- The extension only *describes*. Whether a given facilitator catalogs it is that facilitator's choice; the Celo facilitator's `/discovery/resources` is not documented as available (check `https://api.x402.celo.org/discovery/resources` before promising it).

---

## Registration commands

```bash
# agent402.tools (free; publish https://api.you.com/.well-known/x402 first; re-crawled every 30 min)
curl -X POST https://agent402.tools/api/index/register \
  -H 'content-type: application/json' \
  -d '{"origin":"https://api.you.com"}'
```

- agent402 status check: `https://agent402.tools/api/index?seller=<your origin>`.
- **x402scan**: web form `https://www.x402scan.com/resources/register`, or the SIWX-authenticated `POST /api/x402/registry/register` (Base/Solana resources only).
- **Coinbase index**: settle one paid call through Coinbase's facilitator on a network it supports, keep the Celo offer in `accepts`, repeat at least every 30 days.
- **8004scan**: ERC-8004 registration on Celo (Identity Registry `0x8004A169FB4a3325136EB29fA0ceB6D2e539a432`, Reputation Registry `0x8004BAa17C55a88189AE136b182e5fdA19dE9b63`); registration file `type: https://eips.ethereum.org/EIPS/eip-8004#registration-v1` with `services[]` and `x402Support: true`.
- **Buy catalog**: issue form (link above).

---

## Checklist to hand a project

1. 402 carries `extensions.bazaar` with a ≤ 500-char description, example input, input schema, example output.
2. Origin is public and answers 402 to an unauthenticated request.
3. Service manifest published at `/.well-known/x402`, then the origin registered on agent402.tools.
4. ERC-8004 identity on Celo with `services` + `x402Support: true`.
5. Listing request opened for the Buy catalog.
6. Optional: a second offer on Base (or another supported network) for Coinbase's index and x402scan.
7. Attribution tags on every transaction the seller sends (`attribution-tags.md`).

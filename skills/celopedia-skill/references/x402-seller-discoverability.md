# x402 Seller Discoverability on Celo

> Source: x402 `bazaar` extension spec (github.com/x402-foundation/x402, `specs/extensions/bazaar.md`), `@x402/extensions` 2.27, Coinbase seller docs (`docs.cdp.coinbase.com/x402/seller/get-discovered`), agent402.tools, x402scan, docs.celo.org/build-on-celo/build-with-ai/x402-get-discovered
> Last updated: 2026-09-28.

A working 402 endpoint on Celo is invisible until (1) its 402 response describes the endpoint in a machine-readable way and (2) it is listed where agents look. There is no single index. Use this reference when a builder asks "how do agents find my paid API?" or "how do I get listed?".

---

## The two halves

1. **Self-description** — the x402 `bazaar` extension embeds method, example input, input JSON schema, and example output in the 402. Any facilitator or crawler that understands the extension can catalog the endpoint from the 402 alone.
2. **Registration** — each index has its own entry rule. The table below is the current state.

| Index | Entry | Requirement / caveat |
|-------|-------|----------------------|
| **agent402.tools** | `POST https://agent402.tools/api/index/register` with `{"origin":"https://api.you.com"}` | Free, no account; hourly crawl of the origin's x402 surface; ranks by health. Lists Celo. |
| **Coinbase x402 discovery (Bazaar)** | Automatic after a paid call settles through **Coinbase's** facilitator (TypeScript SDK auto-enrolls; Python opts in per route) | Coinbase's facilitator settles on Base, Base Sepolia, Polygon, Arbitrum, World, Solana — **not on Celo**. An `eip155:42220` offer is shown only next to an offer that settled there ("dual-rail"). Listings with no settlement for 30 days are removed. |
| **x402scan** | Submit the URL at `https://www.x402scan.com/resources/register` | Added if the URL returns a valid challenge; registration accepts **Base and Solana** resources only (Celo-only endpoints are rejected). |
| **8004scan** | Register an ERC-8004 identity on Celo; list endpoints under `services`, set `x402Support: true` in the registration file | Registry addresses and flow: `ai-agents.md` → ERC-8004, docs `/build-on-celo/build-with-ai/8004`. |
| **Buy catalog (usebuy.ai)** | Listing request via the buy-skill issue form `https://github.com/celo-org/buy-skill/issues/new/choose` | Curated; needs origin, description, price, networks, tokens. |

Key consequence for advice: an endpoint that accepts only Celo cannot appear in Coinbase's index or on x402scan today. Recommend **agent402.tools + ERC-8004 + a self-describing 402** as the baseline, and a dual-rail offer (Base via Coinbase's facilitator, Celo via `api.x402.celo.org`) only if the builder specifically needs the Coinbase or x402scan surfaces.

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
- Celo assets are not in the packages' default-asset table: always pass the explicit `price` object (see `ai-agents.md` → x402 gotchas).
- The extension only *describes*. Whether a given facilitator catalogs it is that facilitator's choice; the Celo facilitator's `/discovery/resources` is not documented as available (check `https://api.x402.celo.org/discovery/resources` before promising it).

---

## Registration commands

```bash
# agent402.tools (free, hourly crawl)
curl -X POST https://agent402.tools/api/index/register \
  -H 'content-type: application/json' \
  -d '{"origin":"https://api.you.com"}'
```

- **x402scan**: web form only — `https://www.x402scan.com/resources/register` (Base/Solana resources).
- **Coinbase index**: no call; settle one paid call through Coinbase's facilitator on a network it supports, keep the Celo offer in `accepts`, repeat at least monthly.
- **8004scan**: ERC-8004 registration on Celo (Identity Registry `0x8004A169FB4a3325136EB29fA0ceB6D2e539a432`, Reputation Registry `0x8004BAa17C55a88189AE136b182e5fdA19dE9b63`); registration file `type: https://eips.ethereum.org/EIPS/eip-8004#registration-v1` with `services[]` and `x402Support: true`.
- **Buy catalog**: issue form (link above).

---

## Checklist to hand a project

1. 402 carries `extensions.bazaar` with a ≤ 500-char description, example input, input schema, example output.
2. Origin is public and answers 402 to an unauthenticated request.
3. Registered on agent402.tools (one curl).
4. ERC-8004 identity on Celo with `services` + `x402Support: true`.
5. Listing request opened for the Buy catalog.
6. Optional: dual-rail offer for Coinbase's index and x402scan.
7. Attribution tags on every transaction the seller sends (`attribution-tags.md`).

# Agent Vault (Self Labs) — card payments and logins for agents

> Sources: https://agentvault.io · https://docs.agentvault.io (agent-readable index: https://docs.agentvault.io/llms.txt).
> Last verified: 2026-10-15. Plans, prices, limits, tool lists and the agent list change — re-check the docs before quoting a number or a name.

Agent Vault is a product of **Self Labs** (self.xyz). Self is also the identity project behind [Self Agent ID](self-agent-id.md). It lets an AI agent **pay at online checkouts by card and sign in to websites** on a person's behalf, with spending limits, without the agent ever holding the card number or the password. The agent works with placeholder "mock tokens"; Agent Vault's proxy browser swaps in the real value at the moment of the fill. Developers reach it through an **MCP server, a Playwright SDK or an HTTP API**.

## Read this first: it is not a Celo protocol

Agent Vault's site and documentation **do not mention Celo, blockchains, stablecoins, wallets, x402 or ERC-8004**. It is a card-and-login layer for the ordinary web. Celopedia lists it because Self is part of the Celo ecosystem and builders on Celo will ask about it.

- **Never say** Agent Vault runs on Celo, settles in stablecoins, or integrates with x402, MPP, ERC-8004 or Self Agent ID. None of that is documented. If a builder asks, say it is not documented and point them to team@self.xyz.
- **For onchain agent payments** (stablecoins, pay-per-request, agent identity), use `ai-agents.md` → x402, the hosted facilitator, and ERC-8004 / [Self Agent ID](self-agent-id.md).
- **Use Agent Vault when** the agent has to pay a merchant that only accepts cards, or sign in to a site that has no API. It complements onchain rails; it does not replace them.

| The agent needs to… | Use |
|---|---|
| Pay an API or service per request in stablecoins on Celo | x402 / MPP (`ai-agents.md`) |
| Prove a human stands behind the agent | Self Agent ID (`self-agent-id.md`) |
| Buy something on a normal website with a card | **Agent Vault** |
| Sign in to a website with the user's saved credentials | **Agent Vault** |

## How it works

1. The account holder adds cards, logins, identity and addresses to the vault in the dashboard (`https://app.agentvault.io`).
2. The agent receives **mock tokens** such as `av_card_1_number_u7x2k`. Typed anywhere outside the proxy, a token is just a string.
3. The agent drives a browser that runs **inside Agent Vault's proxy** and fills fields with tokens.
4. At each fill the proxy checks the account holder's rules, swaps the token for the real value and types it into the merchant's page. A login fills only on its registered site (URL locking).

Agent Vault **moves no money**; the merchant and the card issuer keep the financial record. It does not hide the card from the merchant.

## Choose an integration

| Option | Use it when | Auth | Docs |
|---|---|---|---|
| **Hosted MCP server** (most people) | The agent runs in an MCP client (Claude Code, Claude Desktop, Codex, Cursor…) | OAuth sign-in, no API key | https://docs.agentvault.io/mcp/setup |
| **Self-run MCP server** (`@agentvault/mcp`) | You want a local stdio process | API key in the environment | same |
| **Playwright SDK** (`@agentvault/playwright`) | You write the agent in TypeScript and want full browser control | API key | https://docs.agentvault.io/sdk/install |
| **HTTP API** | Everything except driving the browser: token catalog, recipe lookup, signup requests | API key (recipe lookup needs none) | https://docs.agentvault.io/reference/http-api |
| **Agent skill** | The agent should follow the rules without a long system prompt; use with one of the above | None | https://docs.agentvault.io/mcp/rules-of-engagement |

Agent Vault documents 8 agents with their own setup pages (Meta Muse, Grok Bot, OpenClaw, Claude Code, Hermes, Claude Desktop, Antigravity, Codex): https://docs.agentvault.io/agents/overview. Any MCP client that supports streamable HTTP and OAuth can also connect. Hosted MCP server: `https://mcp.agentvault.io/mcp`.

Commands taken verbatim from Agent Vault's docs:

```bash
# Claude Code — then run /mcp, choose agent-vault and sign in
claude mcp add --transport http agent-vault https://mcp.agentvault.io/mcp

# Codex — sign-in starts after the add
codex mcp add agent-vault --url https://mcp.agentvault.io/mcp
```

The docs' one-line alternative for any agent: tell it `Read https://mcp.agentvault.io/skill.md and follow it to connect Agent Vault.`

## MCP tools (29, plus `get_pending_result` on the hosted server)

| Stage | Tools |
|---|---|
| Discover | `get_token_catalog`, `get_checkout_recipes`, `submit_checkout_recipe`, `get_recipe_submission` |
| Open an account | `create_login`, `get_signup_request`, `wait_for_signup_approval`, `set_login_username`, `rotate_login_password` |
| Drive the page | `open_page`, `click`, `press`, `wait_for_selector`, `count`, `wait_for_popup`, `close_popup` |
| Fill | `fill_checkout`, `fill_login`, `declare_page_hint`, `list_page_hint_kinds` |
| Look at the page | `observe_page`, `snapshot_page`, `list_frames`, `detect_challenge`, `get_network_log` |
| Hand off | `request_challenge_handoff` |
| Confirm and finish | `get_session_outcome`, `get_run_report`, `close_session` |

Page tools need an open page: call `open_page` first. A refused call returns an MCP tool error (`isError: true`) whose text is the proxy's message. Full reference: https://docs.agentvault.io/mcp/tool-reference.

## HTTP API

Base URL is your deployment's API URL (`SELF_AGENT_PAY_API_URL`; `https://api.agentvault.io` for the hosted service). Authenticate with an API key as a bearer token.

| Endpoint | Purpose | Auth |
|---|---|---|
| `GET /v1/tokens` | Read the mock token catalog | API key |
| `GET /v1/recipes` | Look up checkout recipes | None |
| `POST /v1/recipes` | Contribute a recipe | API key |
| `GET /v1/recipes/submissions/{id}` | Read a submission's verdict | API key |
| `POST /v1/logins/requests` | Ask the account holder to approve a new login | API key with signup |
| `GET /v1/logins/requests/{id}` | Poll a signup request | The key that filed it |
| `POST /v1/logins/username` | Record the username on an agent-created login | API key with signup |
| `POST /v1/logins/password` | Replace an agent-created login's password | API key with signup |

Driving the browser uses the proxy's WebSocket protocol, so use the SDK or the MCP server for that.

## Playwright SDK

`@agentvault/playwright` is a drop-in for Playwright's `chromium`: every browser action runs in the proxy and token fills resolve there. Server side only; Bun, or Node 20 or later. **It is not on npm** — install from the hosted tarball, then set all three environment variables:

```bash
npm install https://app.agentvault.io/sdk/agentvault-playwright.tgz

# Hosted values; a self-hosted deployment shows its own in the dashboard
export SELF_AGENT_PAY_API_KEY=av_...
export SELF_AGENT_PAY_PROXY_URL=wss://proxy.agentvault.io/v1
export SELF_AGENT_PAY_API_URL=https://api.agentvault.io
```

Exports: `chromium` (`chromium.launch()` opens a proxied browser), `listTokens`, `tokensForUrl`, `defaultIdentity`, `createLogin`, `getSignupRequest`, `awaitSignupApproval`, `setLoginUsername`, `rotateLoginPassword`, `recipesForUrl`, `buyableMerchants`, `submitRecipe`, `recipeSubmission`, `fingerprintUrl`. Reference: https://docs.agentvault.io/sdk/api-reference.

**Error handling:** every proxy or API failure is a `SelfAgentPayError` with a stable `code`. Branch on `code`, never on the message. A few failures escape as native JavaScript errors (saving a screenshot to a file, a network failure in `recipeSubmission()`, a non-JSON body from `listTokens()`), so catch more than `SelfAgentPayError`. Per-code retry guidance, so a retry never charges twice: https://docs.agentvault.io/sdk/error-codes.

## The nine rules for an agent

Published as a page and as an installable skill (paste into a system prompt or install the skill): never type a real card number, CVV or password · never generate a password or email (call `create_login`) · never read back a filled value (`page.evaluate` is disabled) · match the token to the page (URL locking) · hand challenges to the account owner · fill the card in the right order · submit once · read the run report before talking about money · contribute what you learned. https://docs.agentvault.io/mcp/rules-of-engagement

## Limits and timeouts

| Limit | Value |
|---|---|
| Proxy session | Closes after **15 minutes idle** or **60 minutes total** |
| Token catalog requests per key, per minute | Free 60 · Plus 300 · Enterprise 600 |
| Token catalog requests per account, per minute | Free 120 · Plus 600 · Enterprise 1,200 |
| Payments per rolling 30 days | Free 5 · Plus 100 · Enterprise unlimited |
| Agent cards | Free 1 · Plus 5 · Enterprise unlimited |

A card fill counts against spend limits the moment it lands, before any order exists. Spend limits are in USD, rolling windows. Starter defaults: per transaction $75, per day $100 (Plus and Enterprise only), per week $200, per rolling 30 days $500. Foreign totals are converted at a daily reference rate plus a 3% buffer; a total that cannot be read is refused on a capped card (see the Page hints guide: https://docs.agentvault.io/guides/page-hints). Full list: https://docs.agentvault.io/reference/limits.

## Webhooks

Set per agent card, Plus and Enterprise only. Each delivery is a signed JSON `POST` to an HTTPS endpoint; verify the `X-AgentPay-Signature` header with the card's `whsec_…` signing secret. Events: `card_fill`, `denied_fill`, `limit_threshold`, `auto_pause`, `approval_required`. Retried up to five times in total; queuing is best effort, so treat webhooks as alerts, not a ledger. https://docs.agentvault.io/reference/webhooks

## Controls the account holder has

- **Agent card** limits (above), **merchant rules** (block named sites; allow-only lists are Enterprise), **approval** above an amount, **auto-pause** on a breach, and a **kill switch** (dashboard Overview → "Pause all agents").
- A card with **no agent card has no limits**, and every card added after the first starts that way. Give each agent its own agent card and API key.
- An **activity log** (best effort) of what was filled, where, and what was refused.

## Plans (as of 2026-10-15 — verify at https://docs.agentvault.io/dashboard/billing)

Free $0 · Plus $19/month (list $49) · Enterprise via team@self.xyz. Daily limits and webhooks need Plus; merchant allowlists need Enterprise. The first 1,000 Plus subscribers get 3 months free; a card is required and is charged $19/month when the trial ends unless cancelled.

## Gotchas that catch builders

| Symptom | Cause / fix (per Agent Vault's docs) |
|---|---|
| `npm i @agentvault/playwright` fails | The package is **not on npm**. Install from the hosted tarball above |
| `no API key` from `listTokens()` / `chromium.launch()` | Set all three `SELF_AGENT_PAY_*` variables |
| `Failed to connect to proxy` | `SELF_AGENT_PAY_PROXY_URL` is unset, so the SDK targets `ws://localhost:4000/v1` |
| `claude mcp list` shows `Needs authentication` | Sign in with `/mcp` (or `claude mcp login agent-vault`) |
| `cvv_entry_required` | The CVV is never stored. Use a deployment with live CVV entry, where the holder types it in the dashboard |
| `limit_reached` | A spend cap was hit. With auto-pause on, the card stops until resumed |
| `plan_quota_reached` | The plan's payment quota is used up (an account setting, not a card setting) |
| `destination_unauthorized` | A card, CVV, identity or address token was used on a site the holder has not authorized as a destination; the fill waits for approval, then fails without it |

## Security model (per Agent Vault's public docs)

- The agent holds only **mock tokens**. A token works only inside Agent Vault's proxy and only for the account that owns it; typed anywhere else it is a plain string.
- A card number is **tokenized in the account holder's browser** by the card vault provider's own iframe and never reaches Agent Vault's backend. The provider holds a PCI DSS Level 1 attestation. The card security code (CVV) is never stored.
- At fill time the **proxy, which Agent Vault runs, fetches the card number and types it** into the merchant's page, after checking the account holder's rules.
- Revoking a card or login takes effect immediately. A compromised agent can at most make purchases the holder's limits and merchant rules already allow.
- The docs also describe known limits, such as text a merchant page echoes back (the "digit-free echo exception") and an optional hardware-attested card reveal ("attested detokenization") that depends on how a deployment is provisioned. Read https://docs.agentvault.io/security/model and https://docs.agentvault.io/security/attested-detokenization before relying on either.

## Open source

The **Checkout Recipe Registry** is an open catalogue of per-merchant checkout recipes (JSON, with a schema, validator and autonomy benchmark) that any Playwright agent can use with or without Agent Vault; `GET /v1/recipes` needs no key: https://github.com/selfxyz/agent-checkout-skill. Changelog: https://github.com/selfxyz/agent-pay/releases.

## Links

| What | URL |
|---|---|
| Product | https://agentvault.io |
| Docs | https://docs.agentvault.io |
| Dashboard / sign up | https://app.agentvault.io |
| Tool reference | https://docs.agentvault.io/mcp/tool-reference |
| Security model | https://docs.agentvault.io/security/model |
| Company | Self Labs — https://self.xyz · team@self.xyz |

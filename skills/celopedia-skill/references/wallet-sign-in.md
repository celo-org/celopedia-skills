# Wallet Sign-In on Celo (SIWE, Supabase Auth)

> **Single source of truth:** https://docs.celo.org/build/sign-in-with-celo-wallet
> **Upstream:** https://supabase.com/docs/guides/auth/auth-web3 ·
> https://eips.ethereum.org/EIPS/eip-4361 · Supabase Auth source
> (`internal/api/web3.go`, `internal/utilities/siwe/` in `supabase/auth`).
> **Companion files:** `minipay-guide.md` (MiniPay connection), `minipay-common-mistakes.md` §2.
> Last updated: 2026-11-26.

**Load this file when a builder wants users to log in with a wallet** ("sign in with
wallet", "SIWE", "Sign-In with Ethereum", "wallet auth", "Supabase web3 login", "login
without email"). It is a decision router plus the gotchas that are not in the SDK docs.

---

## First question: is the app a MiniPay Mini App?

**Yes → no message signing at all.** MiniPay does not support `personal_sign` or
`eth_signTypedData`; a sign-in prompt never resolves, and Mini Apps must not ask users to
sign to access or authenticate. Auto-connect on load and use the connected account.
→ `minipay-common-mistakes.md` §2, `minipay-guide.md` → _Important Constraints_ #4.

**No (web app with browser wallets such as MetaMask) → SIWE, pick a verifier:**

| Need | Use | Why |
|---|---|---|
| Supabase backend, EOA wallets | Supabase Auth `signInWithWeb3({ chain: "ethereum" })` | Returns a normal Supabase session; RLS works with `auth.uid()` |
| Smart contract wallets (ERC-1271 / ERC-6492) must work | Verify on your server with viem `publicClient.verifySiweMessage` on `celo` | Supabase only accepts 65-byte EOA signatures |
| No Supabase | viem `createSiweMessage` + `verifySiweMessage`, your own session | Same checks, you own nonce + session |

## Supabase Auth on Celo: verified facts

- `chain: "ethereum"` covers every EVM chain. Supabase accepts **any positive chain ID**,
  Celo `42220` included (`isValidEthereumNetwork` → `chainId > 0`).
- Requires `@supabase/supabase-js` **2.58.0+** (bundles `@supabase/auth-js` 2.72.0, the
  first with Ethereum in `signInWithWeb3`).
- Force Celo in the message: `options: { signInWithEthereum: { chainId: 42220 } }`.
  Without it the SDK uses the wallet's `eth_chainId`.
- **Supabase does not enforce the chain.** The user is keyed on the address only
  (`web3:ethereum:<lowercase address>`), so the same address on any EVM chain is one
  user. The chain ID of the **latest** sign-in lands as a **string** (`"42220"`) in
  `user_metadata.custom_claims.network` and in `auth.identities.identity_data`.
- **Never gate RLS on `user_metadata`.** The user can rewrite it with
  `supabase.auth.updateUser({ data })`; a chain-1 sign-in that sets `network: "42220"`
  passes a `auth.jwt() -> 'user_metadata'` policy (reproduced against a live project).
  Read `identity_data` from `auth.identities` in a `security definer` function in a
  non-exposed schema (`private`) — SQL on the docs page, _Accept only Celo_.
- Replay protection is time-based: the message must be issued within the provider's
  `maximum_validity_duration` (default **10 minutes**). Supabase does not track nonces.
- The page URL must be in **Redirect URLs**; the message URI must be `https` (or
  `localhost`) and its host must equal the message domain.
- Enable abuse controls: Web3 sign-ups are free to automate. Set the Web3 rate limit and
  CAPTCHA (see the Supabase guide).

## Gotchas → exact errors

| Symptom / error string | Cause | Fix |
|---|---|---|
| `signature must be 65 bytes long, encoded as a 130 character-long hexadecimal string` | Smart contract wallet signature | Verify server-side with viem `verifySiweMessage` |
| `Signed Ethereum message is using URI which is not allowed on this server, message was signed for another app` | Page URL missing from Redirect URLs | Add `https://<domain>/**` |
| `Ethereum message was issued too long ago` | > 10 min between building and sending | Re-sign |
| `Web3 provider is disabled` (no Web3 provider on) or `Ethereum Web3 provider is disabled` (only Solana on) | Provider off | Enable Web3 Wallet → Ethereum at `https://supabase.com/dashboard/project/_/auth/providers` |
| `@supabase/auth-js: Wallet method eth_requestAccounts is missing or invalid` | The SDK replaces **every** `eth_requestAccounts` failure with this text: user rejection and MetaMask `-32002` ("request already pending") included | Tell the user to open the wallet extension and resolve the pending request; don't show "unsupported wallet" |
| Wrong wallet opens / "MetaMask" is actually another extension | Several extensions fight over `window.ethereum` | Discover with EIP-6963 and pass the chosen provider as `wallet` |

## Custom verifier checklist (viem, no Supabase)

- Nonce from `generateSiweNonce()` (`viem/siwe`), stored server-side or in a signed
  httpOnly cookie, single use.
- Compare the message domain against a **fixed allowlist**, never against the request
  `Host` header.
- Check `chainId === 42220` before calling `verifySiweMessage`.
- `verifySiweMessage` also checks the address, `expirationTime` and `notBefore`.

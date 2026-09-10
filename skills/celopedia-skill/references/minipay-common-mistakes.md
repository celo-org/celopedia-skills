# MiniPay Common Mistakes

> **Single source of truth:** https://docs.minipay.xyz/ — see
> `minipay-docs-map.md` for the page-by-page index.
> **Companion files:** `minipay-requirements.md` (the full listing checklist),
> `minipay-guide.md` (how to build each piece), `minipay-templates.md`
> (drop-in code), `minipay-performance.md` (load speed).
> Last updated: 2026-09-10.

**Load this file when a Mini App is failing review, was rejected, or is
misbehaving in production.** It is a router, not a tutorial: each entry is
symptom → why it fails → the fix → where the detail lives. Nothing here is
re-explained; follow the pointer.

For a pre-build "should I even target MiniPay?" assessment, use
`minipay-app-fit.md`. For the submission checklist itself, use
`minipay-requirements.md`.

---

## Blocking — these get an app rejected

### 1. A "Connect Wallet" button appears inside MiniPay

**Why it fails:** MiniPay injects the provider and the user is already
authenticated. A connect step is friction with no purpose, and it is the single
most common rejection reason.
**Fix:** auto-connect on load when `window.ethereum.isMiniPay === true`, and
hide the connect UI entirely.
→ `minipay-guide.md` → _MiniPay Detection_ / _Wallet Connection_ ·
`minipay-templates.md` §1–2

### 2. The app asks users to sign a message

**Why it fails:** MiniPay does not support `personal_sign` or
`eth_signTypedData`. The prompt never resolves; the flow dead-ends.
**Fix:** authenticate from the connected account alone. If you need
server-side identity, bind it to the account without a signature.
→ `minipay-guide.md` → _Important Constraints_ #4

### 3. The wallet address is displayed, copyable, or shareable

**Why it fails:** apps must not display, copy, or share the user's address —
a user-safety rule. **A truncated `0x123…abc` does not count as an exception.**
Copy buttons, share sheets, and address QR codes are all covered.
**Fix:** identify users by phone number (ODIS) or an app-specific alias. Keep
the address in state for `balanceOf` and as the transaction `account` — just
never render it.
→ `minipay-requirements.md` §1 · `minipay-guide.md` → _UI rule: never expose
wallet addresses_ · `odis-socialconnect.md`

### 4. There is a "withdraw to address" field

**Why it fails:** withdrawals to arbitrary or external wallet addresses are
strictly prohibited.
**Fix:** pay out only to a destination the app controls or that MiniPay
resolves (the connected user, or a phone number via ODIS). Remove free-text
and paste-an-address inputs.
→ `minipay-requirements.md` §1

### 5. The app does not support USDT

**Why it fails:** USDT support is **mandatory** for every Mini App. A
USDC-only or USDm-only app is not listable.
**Fix:** add USDT (6 decimals, `feeCurrency` **adapter** address — see #8).
→ `minipay-requirements.md` §2

### 6. CELO, "gas", "onramp", or "crypto" appear in the UI

**Why it fails:** MiniPay hides CELO from users and enforces plain-language
copy. Fee abstraction pays the network fee in stablecoins automatically.
**Fix:** remove CELO from balances, selectors, and copy. Say **Network fee**,
**Deposit**, **Withdraw**, **Stablecoin**. Code identifiers (`feeCurrency`,
`eth_gasPrice`) stay as they are.
→ `minipay-requirements.md` §3 · celopedia `SKILL.md` → Important Rules #9

### 7. Balance is checked against the amount, but not the fee

**Why it fails:** the network fee is paid in the same stablecoin, so the real
precondition is `balance >= amount + fee`. Checking the amount alone lets an
unaffordable transaction through; it reverts in the user's face.
**Fix:** estimate the fee (`estimateGas` + `eth_gasPrice` with `feeCurrency`),
compare against `amount + fee`, and on a shortfall explain it and redirect to
`https://link.minipay.xyz/add_cash` instead of throwing a raw error.
→ `minipay-requirements.md` §2 · `minipay-templates.md` §7 ·
`minipay-guide.md` → _Pre-flight check_

### 8. Transactions fail only for USDC/USDT

**Why it fails:** USDC and USDT need their **`feeCurrency` adapter** address,
not the token address. Passing the token address makes the transaction fail.
USDm (18 decimals) is the exception — token address doubles as `feeCurrency`.
**Fix:** use the adapter for 6-decimal tokens.
→ `minipay-guide.md` → _Supported Stablecoins_ · `builder-guide.md` →
_Allowed Fee Currencies (Mainnet)_

### 9. Amounts are off by orders of magnitude

**Why it fails:** USDC and USDT have **6** decimals; USDm has **18**. A shared
`parseUnits(x, 18)` silently overcharges or undercharges by 10¹².
**Fix:** carry decimals per token and never hardcode 18. Bridged variants can
differ again — verify on Celoscan.
→ `minipay-guide.md` → _Supported Stablecoins_ · `minipay-templates.md` §5

### 10. On-chain actions have no pending / success / failure states

**Why it fails:** a dead button during signing, or a success state fired on
submission rather than confirmation, both read as a broken app.
**Fix:** three explicit states. Pending from the signature prompt through
confirmation; success only on `waitForTransactionReceipt`; failure with
descriptive copy. **Map errors from codes and error names, not message text** —
message strings change between provider versions and locales.
→ `minipay-requirements.md` §9 · `minipay-templates.md` §7

### 11. PageSpeed score is too low

**Why it fails:** high performance is a stated prerequisite for listing, and
MiniPay's users are on budget Android phones and mobile networks.
**Fix:** run https://pagespeed.web.dev on the production URL and work the
playbook — font loading first, then lazy-loading the wallet SDK, then
deferring non-critical scripts.
→ `minipay-performance.md` · `minipay-requirements.md` §4

### 12. The UI breaks on a small screen

**Why it fails:** the app must be fully functional at **360 × 640**, the
minimum MiniPay WebView resolution.
**Fix:** test in Chrome DevTools device mode at 360 × 640 before submitting.
Touch targets ≥ 44 × 44 px.
→ `minipay-requirements.md` §4

### 13. About / How to Use / legal / support links are missing

**Why it fails:** Privacy Policy, Terms & Conditions, Support/Contact,
**About**, and **How to Use** must all be reachable from the footer or menu.
The last two are the ones most often missed.
**Fix:** add all five, plus an explicit line stating the app is operated by
your organisation and **not** by Opera or MiniPay.
→ `minipay-requirements.md` §7

### 14. The first version tries to do everything

**Why it fails:** long multi-step flows are the most common source of both
user friction and technical failures during review.
**Fix:** ship the core flow only; add the rest in a later version.
→ `minipay-requirements.md` §4

---

## Post-listing — these break an app that already passed

### 15. Calls fail in production on a build that works everywhere else

**Why it fails:** after approval, MiniPay whitelists the exact **contract
addresses, method signatures, parameters, and URLs** you submitted, and
enforces them at transaction time. **Adding a parameter to a whitelisted
method changes the selector**; redeploying changes the address; a new
subdomain or CDN host is a new origin. Any of these gets rejected before the
transaction is broadcast — which is easy to misdiagnose as a code bug, because
the same build works fine outside MiniPay.
**Fix:** submit the production-ready build with a frozen ABI and URL set.
Treat any later address/signature/URL change as **requiring re-whitelisting**,
coordinated before you ship.
→ `minipay-requirements.md` §10

### 16. A dependency update introduces a supply-chain risk

**Why it fails:** Mini Apps handle user funds inside a wallet, so the
dependency tree is in scope for review.
**Fix:** pin exact npm versions (no `^`/`~`), wait 7+ days before adopting a
new version, set `ignore-scripts=true` in `.npmrc`, commit the lockfile, and
use frozen installs in CI.
→ `minipay-requirements.md` §11

---

## Platform quirks — not your bug

### 17. Geolocation hangs forever on iOS

MiniPay iOS does not bridge `navigator.geolocation` to the OS.
`getCurrentPosition` and `watchPosition` never fire a callback, even with
location permission granted. The same code works in other in-app browsers.
**Workaround:** detect `isIOS && window.ethereum.isMiniPay` and offer a deep
link out. Tracked at https://github.com/celo-org/minipay/issues/44.
→ `minipay-guide.md` → _Important Constraints_ #9

### 18. Transactions are rejected after setting EIP-1559 fields

MiniPay uses legacy transactions and ignores `maxFeePerGas` /
`maxPriorityFeePerGas`. Remove them.
→ `minipay-guide.md` → _Important Constraints_ #2

### 19. Nothing works in the emulator

MiniPay requires a physical Android device. Use ngrok + Developer Mode.
→ `minipay-guide.md` → _Testing with ngrok_

---

## Related References

- `minipay-requirements.md` — the full two-stage listing checklist
- `minipay-guide.md` — detection, transfers, deeplinks, constraints
- `minipay-templates.md` — drop-in code, including §7 pre-flight + status
- `minipay-app-fit.md` — should you target MiniPay at all?
- `minipay-performance.md` — hitting the PageSpeed bar
- `minipay-docs-map.md` — page-by-page index of `docs.minipay.xyz`

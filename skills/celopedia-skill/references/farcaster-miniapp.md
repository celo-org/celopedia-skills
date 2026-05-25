# Farcaster Mini Apps on Celo

Practical recipe for shipping a Celo dapp as a Farcaster Mini App. The official docs at https://miniapps.farcaster.xyz are solid; this file documents the gotchas you hit anyway.

## Packages

```bash
npm i @farcaster/miniapp-sdk @farcaster/miniapp-wagmi-connector
```

- `@farcaster/miniapp-sdk` — host SDK. You MUST call `sdk.actions.ready()` once your UI has painted, otherwise Farcaster keeps showing its splash screen forever.
- `@farcaster/miniapp-wagmi-connector` — wagmi connector that exposes the Farcaster host's wallet to your app. Without it, wallet auto-connect inside Warpcast / Coinbase Wallet / the Farcaster preview tool just fails silently.

## Call ready() to dismiss the splash

Drop a small client component anywhere in your tree (e.g. in your root layout):

```tsx
"use client";
import { useEffect } from "react";

export function FarcasterReady() {
  useEffect(() => {
    void (async () => {
      const mod = await import("@farcaster/miniapp-sdk");
      await mod.sdk.actions.ready();
    })();
  }, []);
  return null;
}
```

Outside Farcaster (regular browser, MiniPay, etc.) `ready()` is a no-op, safe to call always. Dynamic import keeps the SDK out of your server bundle.

## Wagmi connector order matters

```ts
import farcasterMiniApp from "@farcaster/miniapp-wagmi-connector";
import { injected } from "wagmi/connectors";

export const wagmiConfig = createConfig({
  chains: [celo],
  connectors: [farcasterMiniApp(), injected()], // farcaster FIRST
  ssr: true,
  storage: createStorage({ storage: cookieStorage }),
  transports: { [celo.id]: http() },
});
```

If `injected()` comes first, wagmi can pick the injected provider before Farcaster's auto-connect runs, and you'll see a stuck "connecting" state inside Warpcast.

## Manifest at /.well-known/farcaster.json

Farcaster discovers and validates your Mini App via `https://YOURDOMAIN/.well-known/farcaster.json`. Minimum useful shape:

```json
{
  "accountAssociation": {
    "header": "...",
    "payload": "...",
    "signature": "..."
  },
  "frame": {
    "version": "1",
    "name": "YourApp",
    "iconUrl": "https://yourdomain.com/icon-512.png",
    "homeUrl": "https://yourdomain.com",
    "splashImageUrl": "https://yourdomain.com/splash.png",
    "splashBackgroundColor": "#FF6B35",
    "buttonTitle": "Open",
    "primaryCategory": "games"
  }
}
```

The `accountAssociation` block is generated once via Warpcast (sign with the custody address of your FID). It binds the domain to that FID. Without it, your Mini App can't be listed publicly.

## Validation gotchas

The Farcaster Preview Tool will flag these and refuse to publish:

- **`description` cannot contain special characters** (`@ # $ % ^ & * + = / \ | ~ « »`). Replace `EN/ES` with `English and Spanish`, etc.
- **`castShareUrl` must be on the same domain as `homeUrl`.** A direct `https://warpcast.com/~/compose?...` URL is rejected. Workaround: ship a `/share` route on your own domain that 302-redirects to the Warpcast compose intent:

  ```ts
  // app/share/route.ts
  export async function GET(request: Request) {
    const url = new URL(request.url);
    const text = url.searchParams.get("text") ?? "default text";
    const embed = url.searchParams.get("embed") ?? "https://yourdomain.com";
    const intent = `https://warpcast.com/~/compose?text=${encodeURIComponent(text)}&embeds[]=${encodeURIComponent(embed)}`;
    return NextResponse.redirect(intent, 302);
  }
  ```

- **`iconUrl` must resolve to a real PNG**, not a Next.js dynamic route with a hash query param like `/icon?abc123`. Either commit a static PNG to `/public` or write an explicit `app/icon-512.png/route.ts` returning a stable PNG URL.

## Hydration mismatch (React error #418)

If your home page renders different UI based on wallet state, the Farcaster Preview Tool will throw React error #418 because SSR rendered "not connected" and the client immediately auto-connects to a different state.

Fix: gate the wallet-dependent UI behind a `mounted` flag.

```tsx
const [mounted, setMounted] = useState(false);
useEffect(() => { setMounted(true); }, []);

return mounted ? <PrimaryCTA /> : <Placeholder />;
```

## Don't race wagmi's cookie reconnect

If your app supports both Farcaster and other wallets, the Farcaster auto-connect (`wagmiConnect({ connector: farcasterMiniApp })`) can fire WHILE wagmi is still trying to restore the cookie-persisted previous connection. They fight, one hangs.

Gate the Farcaster connect on `!isReconnecting`:

```ts
useEffect(() => {
  if (isConnected || isConnectPending || isReconnecting) return;
  // ...then check sdk.isInMiniApp() and connect
}, [isConnected, isConnectPending, isReconnecting]);
```

This is what saves you from the "Signing in... forever" trap inside MetaMask in-app browser and similar.

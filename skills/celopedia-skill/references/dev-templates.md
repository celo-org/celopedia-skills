# Development Templates for Celo

Ready-to-use configuration and code snippets for building on Celo.

> **Building a Mini App for MiniPay?**
> This file covers general Celo dev setup (Foundry, Hardhat, viem, wagmi). For a MiniPay-specific
> scaffold with detection, auto-connect, fee abstraction, and ngrok testing already wired, use:
>
> - `minipay-scaffold-from-scratch.md` — minimal Next.js + viem setup (recommended for Mini Apps)
> - `minipay-templates.md` — copy-paste code for 6 common patterns (payments, balances, deeplinks)
> - `minipay-app-fit.md` — scorecard to check if your idea is a good fit before you start building
>
> Or scaffold immediately with: `npx @celo/celo-composer@latest create -t minipay`

---

## Foundry Configuration

### `foundry.toml`

```toml
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
solc_version = "0.8.28"
evm_version = "cancun"

[profile.default.rpc_endpoints]
celo = "https://forno.celo.org"
celo_sepolia = "https://forno.celo-sepolia.celo-testnet.org"

[etherscan]
celo = { key = "${CELOSCAN_API_KEY}", url = "https://api.celoscan.io/api" }
celo_sepolia = { key = "${CELOSCAN_API_KEY}", url = "https://api-sepolia.celoscan.io/api" }
```

### Deploy Script

```solidity
// script/Deploy.s.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/MyContract.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyContract myContract = new MyContract();
        console.log("Deployed at:", address(myContract));

        vm.stopBroadcast();
    }
}
```

### Deploy Commands

```bash
# Deploy to Celo Sepolia
forge script script/Deploy.s.sol --rpc-url celo_sepolia --broadcast

# Deploy to Celo Mainnet
forge script script/Deploy.s.sol --rpc-url celo --broadcast

# Verify on Celoscan
forge verify-contract <ADDRESS> MyContract \
  --chain-id 42220 \
  --etherscan-api-key $CELOSCAN_API_KEY \
  --verifier-url https://api.celoscan.io/api
```

### Fork Testing

```bash
# Run tests against Celo mainnet fork
forge test --fork-url https://forno.celo.org -vvv

# Run tests against Celo Sepolia fork
forge test --fork-url https://forno.celo-sepolia.celo-testnet.org -vvv
```

---

## Hardhat Configuration

### `hardhat.config.ts`

```typescript
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: { enabled: true, runs: 200 },
      evmVersion: "cancun",
    },
  },
  networks: {
    celo: {
      url: "https://forno.celo.org",
      chainId: 42220,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
    celoSepolia: {
      url: "https://forno.celo-sepolia.celo-testnet.org",
      chainId: 11142220,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    },
  },
  etherscan: {
    apiKey: {
      celo: process.env.CELOSCAN_API_KEY || "",
      celoSepolia: process.env.CELOSCAN_API_KEY || "",
    },
    customChains: [
      {
        network: "celo",
        chainId: 42220,
        urls: {
          apiURL: "https://api.celoscan.io/api",
          browserURL: "https://celoscan.io",
        },
      },
      {
        network: "celoSepolia",
        chainId: 11142220,
        urls: {
          apiURL: "https://api-sepolia.celoscan.io/api",
          browserURL: "https://sepolia.celoscan.io",
        },
      },
    ],
  },
};

export default config;
```

### Deploy & Verify

```bash
# Deploy
npx hardhat run scripts/deploy.ts --network celoSepolia

# Verify
npx hardhat verify --network celo <CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>
```

---

## Viem Client Setup

### Basic Public + Wallet Client

```typescript
import { createPublicClient, createWalletClient, http, custom } from "viem";
import { celo, celoSepolia } from "viem/chains";

// Read-only client
const publicClient = createPublicClient({
  chain: celo,
  transport: http("https://forno.celo.org"),
});

// Browser wallet client (MetaMask, MiniPay, etc.)
const walletClient = createWalletClient({
  chain: celo,
  transport: custom(window.ethereum),
});

// Server-side wallet client
import { privateKeyToAccount } from "viem/accounts";

const account = privateKeyToAccount("0x...");
const serverWalletClient = createWalletClient({
  account,
  chain: celo,
  transport: http("https://forno.celo.org"),
});
```

### Transaction with Fee Abstraction

```typescript
const txHash = await walletClient.sendTransaction({
  account: "0x...",
  to: "0x...",
  value: 0n,
  data: "0x...",
  feeCurrency: "0x765DE816845861e75A25fCA122bb6898B8B1282a", // Pay gas in USDm
});

const receipt = await publicClient.waitForTransactionReceipt({ hash: txHash });
```

### Read Contract

```typescript
const balance = await publicClient.readContract({
  address: "0x765DE816845861e75A25fCA122bb6898B8B1282a",
  abi: erc20Abi,
  functionName: "balanceOf",
  args: ["0xYourAddress"],
});
```

---

## Wagmi + RainbowKit Setup

### `wagmi.config.ts`

```typescript
import { http, createConfig } from "wagmi";
import { celo, celoSepolia } from "wagmi/chains";
import { getDefaultConfig } from "@rainbow-me/rainbowkit";

export const config = getDefaultConfig({
  appName: "My Celo App",
  projectId: "YOUR_WALLETCONNECT_PROJECT_ID",
  chains: [celo, celoSepolia],
  transports: {
    [celo.id]: http("https://forno.celo.org"),
    [celoSepolia.id]: http("https://forno.celo-sepolia.celo-testnet.org"),
  },
});
```

### Provider Setup

```tsx
import { WagmiProvider } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { RainbowKitProvider } from "@rainbow-me/rainbowkit";
import "@rainbow-me/rainbowkit/styles.css";
import { config } from "./wagmi.config";

const queryClient = new QueryClient();

export default function App({ children }: { children: React.ReactNode }) {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider>
          {children}
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}
```

### Send Transaction with Fee Currency

```tsx
import { useSendTransaction } from "wagmi";
import { parseEther } from "viem";

function SendCelo() {
  const { sendTransaction } = useSendTransaction();

  function handleSend() {
    sendTransaction({
      to: "0xRecipient",
      value: parseEther("0.01"),
      feeCurrency: "0x765DE816845861e75A25fCA122bb6898B8B1282a", // USDm
    });
  }

  return <button onClick={handleSend}>Send 0.01 CELO</button>;
}
```

---

## Scaffold a New Celo dApp

### Celo Composer templates

`-t` takes exactly four values. Anything else falls back to `basic` rather than erroring, so a
typo scaffolds the wrong project silently — check what you got before building on it.

| `-t` | Shape | What you get on top of the base | Wallet / contracts default |
|------|-------|--------------------------------|----------------------------|
| `basic` | monorepo (`apps/web`, `apps/contracts`) | Next.js + wagmi + viem + RainbowKit, Hardhat alongside | `rainbowkit` / `hardhat` |
| `minipay` | monorepo (`apps/web`, `apps/contracts`) | `basic` **plus** MiniPay detection (`window.ethereum.isMiniPay`), auto-connect in the wallet provider and connect button, and a `user-balance.tsx` component | `rainbowkit` / `hardhat` |
| `farcaster-miniapp` | monorepo (`apps/web` only) | `@farcaster/frame-sdk`, `frame-core`, `miniapp-wagmi-connector`, `quick-auth`, plus a `FARCASTER_SETUP.md` | `none` / `none` |
| `ai-chat` | **single app at the repo root — not a monorepo** | Vercel AI SDK chat app: `@ai-sdk/{anthropic,google,mistral,openai,perplexity,react}`, artifacts, Drizzle + Postgres, auth, Playwright tests | `none` / `none` |

```bash
# Agent / chatbot — the AI SDK starter (no contracts, no wallet, needs a Postgres URL)
npx @celo/celo-composer@latest create -t ai-chat

# MiniPay Mini App — basic + MiniPay detection and auto-connect
npx @celo/celo-composer@latest create -t minipay

# Farcaster Mini App
npx @celo/celo-composer@latest create -t farcaster-miniapp

# Plain Celo dApp
npx @celo/celo-composer@latest create -t basic

# With Thirdweb (not Composer)
npx thirdweb create app --evm
```

**Compose the pieces independently of the template:**

```bash
--wallet-provider rainbowkit|thirdweb|none
-c, --contracts   hardhat|foundry|none
--skip-install    # scaffold only, no pnpm install
-y                # accept defaults, no prompts
```

**Things worth knowing before you pick:**

- **`ai-chat` is the odd one out.** It is not a monorepo and ships no contracts or wallet wiring —
  it is the Vercel AI chat starter with Celo defaults, so a Celo transaction path is yours to add.
  It also expects a Postgres database (Drizzle migrations run on `build`), which the other three
  do not.
- **`minipay` is `basic` plus a MiniPay layer**, not a separate lineage. If you already scaffolded
  `basic`, you are ~5 files away from the `minipay` output rather than needing to start over.
- **`farcaster-miniapp` has no `apps/contracts`.** Add one with `-c hardhat` if you need it.
- For a MiniPay Mini App you may not want Composer at all — see
  `minipay-scaffold-from-scratch.md` for a single-app Next.js + viem setup.

> Verified 2026-09-02 against `@celo/celo-composer@2.4.13` (node v20.19.4, darwin): all four
> scaffold with exit 0. File counts — `basic` 32, `minipay` 33, `farcaster-miniapp` 40,
> `ai-chat` 173. The silent-fallback warning is measured, not assumed: `-t nonsense` also exits 0
> and produces the same 32 files as `basic`. Template list taken from `create --help`, not from
> the package's `templates/` directory, which also contains `contracts/` and `wallets/` — those
> are the `-c` and `--wallet-provider` pieces, not `-t` values.

---

## Environment Variables Template

```bash
# .env
PRIVATE_KEY=0x...                           # Deployer private key
CELOSCAN_API_KEY=...                        # From celoscan.io/myapikey
WALLETCONNECT_PROJECT_ID=...                # From cloud.walletconnect.com
CELO_RPC_URL=https://forno.celo.org         # Or your Alchemy/QuickNode URL
```

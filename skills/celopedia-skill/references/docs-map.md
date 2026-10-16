# Celo Documentation Map

> Source: https://docs.celo.org/llms.txt
> OpenAPI Spec: https://docs.celo.org/api-reference/openapi.json — **404 as of 2026-10-16**
> (pre-existing, not something this run's restructuring caused; flagged, not otherwise acted on).
> Last updated: 2026-10-16

Use this to find the right documentation page for any topic. Links go directly to docs.celo.org.

> **Second restructuring in two weeks.** docs.celo.org renamed `infra-partners/*` to
> `operate/*` and folded `specs/*` into `operate/specification/*` around 2026-08-24–09-10 (that
> rename is stable and reflected below). Then, on **2026-10-06** — the day after this file was
> last updated — it renamed `home/*` to `learn/*` and merged `build-on-celo/*` + `tooling/*`
> into a single `build/*` tree (AI/agent pages moved to `build/agents/*`, everything else under
> `tooling/*` moved to `build/tools/*`). Every URL below reflects the **2026-10-16** structure.

---

## Learn (formerly "Home")

> `home/*` → `learn/*`, renamed 2026-10-06.

| Topic | URL |
|-------|-----|
| What is Celo? | https://docs.celo.org/learn/celo |
| Discover Celo | https://docs.celo.org/learn/index |
| Our History | https://docs.celo.org/learn/history |
| About Celo L1 | https://docs.celo.org/learn/celo-l1 |
| Network Information | https://docs.celo.org/learn/network/overview |
| L2 Architecture | https://docs.celo.org/learn/network/architecture |

> Network Information and L2 Architecture used to live under `build-on-celo/*`
> (`network-overview`, `cel2-architecture`) — they moved into this `learn/network/*` subtree,
> not into `build/*` like the rest of the old `build-on-celo` pages.

## Learn — Protocol

| Topic | URL |
|-------|-----|
| Celo Protocol Overview | https://docs.celo.org/learn/protocol/index |
| CELO Token Duality | https://docs.celo.org/learn/protocol/celo-token |
| Transactions Overview | https://docs.celo.org/learn/protocol/transactions/overview |
| Transaction Types | https://docs.celo.org/learn/protocol/transactions/transaction-types |
| Encrypted Payment Comments | https://docs.celo.org/learn/protocol/transactions/tx-comment-encryption |
| Governance Overview | https://docs.celo.org/learn/protocol/governance/overview |
| Create Governance Proposal | https://docs.celo.org/learn/protocol/governance/create-governance-proposal |
| Governance Cheat Sheet | https://docs.celo.org/learn/protocol/governance/governable-parameters |
| Governance Toolkit | https://docs.celo.org/learn/protocol/governance/governance-toolkit |
| Voting in Governance | https://docs.celo.org/learn/protocol/governance/voting-in-governance |
| Voting with Mondo | https://docs.celo.org/learn/protocol/governance/voting-in-governance-using-mondo |
| Smart Contract Upgrades | https://docs.celo.org/learn/protocol/governance/smart-contracts-upgrades |
| Security Council | https://docs.celo.org/learn/protocol/security-council |
| Challengers | https://docs.celo.org/learn/protocol/challengers |
| Metadata and Claims | https://docs.celo.org/learn/protocol/metadata |
| L2 Epoch Rewards | https://docs.celo.org/learn/protocol/epoch-rewards/index |
| Carbon Offsetting Fund | https://docs.celo.org/learn/protocol/epoch-rewards/carbon-offsetting-fund |
| Community Fund | https://docs.celo.org/learn/protocol/epoch-rewards/community-fund |
| Escrow | https://docs.celo.org/learn/protocol/escrow |

## Learn — Staking

| Topic | URL |
|-------|-----|
| Staking (index) | https://docs.celo.org/learn/protocol/staking/index |
| Locked CELO | https://docs.celo.org/learn/protocol/staking/locked-celo |
| Validator Elections | https://docs.celo.org/learn/protocol/staking/validator-elections |
| Validator Groups | https://docs.celo.org/learn/protocol/staking/validator-groups |
| Voting for Validator Groups | https://docs.celo.org/learn/protocol/staking/voting |
| Key Management Summary | https://docs.celo.org/learn/protocol/staking/key-management/summary |
| Detailed Role Descriptions | https://docs.celo.org/learn/protocol/staking/key-management/detailed |
| Signer Key Rotation | https://docs.celo.org/learn/protocol/staking/key-management/key-rotation |

## Managing Assets

> Moved from `home/*` to `learn/*` along with the rest of the Home section (2026-10-06). Two
> new pages (programmatic CELO bridging to/from Ethereum) appeared alongside the rename.

| Topic | URL |
|-------|-----|
| Wallets | https://docs.celo.org/learn/wallets |
| Exchanges | https://docs.celo.org/learn/exchanges |
| Ramps | https://docs.celo.org/learn/ramps |
| Gas Fees | https://docs.celo.org/learn/gas-fees |
| Self-Custody | https://docs.celo.org/learn/manage/self-custody |
| ReleaseGold | https://docs.celo.org/learn/manage/release-gold |
| Asset Management | https://docs.celo.org/learn/manage/asset |
| Bridging | https://docs.celo.org/learn/bridged-tokens/bridges |
| Bridging Native ETH | https://docs.celo.org/learn/bridged-tokens/native-ETH-bridging |
| Bridging CELO from Ethereum | https://docs.celo.org/learn/bridged-tokens/bridging-celo-from-ethereum |
| Withdrawing CELO to Ethereum | https://docs.celo.org/learn/bridged-tokens/withdrawing-celo-to-ethereum |

> "Exchange Assets" (`home/manage/exchange`, later `learn/manage/exchange`) remains removed from
> the live sitemap — "Exchanges" above still covers where to buy/swap CELO.

---

## Build

> `build-on-celo/*` → `build/*`, renamed 2026-10-06 along with the Home→Learn rename.

| Topic | URL |
|-------|-----|
| Building Apps on Celo (index) | https://docs.celo.org/build/index |
| Quickstart | https://docs.celo.org/build/quickstart |
| Launch Checklist | https://docs.celo.org/build/launch-checklist |
| Scaling Your App | https://docs.celo.org/build/scaling-your-app |
| Fund your Project | https://docs.celo.org/build/fund-your-project |
| Nightfall Privacy Layer | https://docs.celo.org/build/nightfall |
| Build with Farcaster | https://docs.celo.org/build/build-with-farcaster |
| Build with Self (ZK Identity) | https://docs.celo.org/build/build-with-self |
| Build with Local Stablecoins | https://docs.celo.org/build/build-with-local-stablecoin |
| Build with USA₮ | https://docs.celo.org/build/build-with-usat |
| Introduction to SocialConnect | https://docs.celo.org/build/build-on-socialconnect |
| Build with DeFi | https://docs.celo.org/build/build-with-defi |

## Build — Agents (formerly "Build with AI")

> `build-on-celo/build-with-ai/*` → `build/agents/*` — renamed, not just reprefixed. Attribution
> Tags also moved here (was a standalone `build-on-celo/attribution-tags` page).

| Topic | URL |
|-------|-----|
| Build with AI on Celo (overview) | https://docs.celo.org/build/agents/overview |
| Use Celo Docs with AI Tools | https://docs.celo.org/build/agents/use-docs-with-ai |
| ERC-8004: Agent Trust Protocol | https://docs.celo.org/build/agents/8004 |
| Self Agent ID | https://docs.celo.org/build/agents/self-agent-id |
| Agent Vault: Card Payments and Logins for Agents | https://docs.celo.org/build/agents/agent-vault |
| x402: Agent Payments | https://docs.celo.org/build/agents/x402 |
| x402: Get your endpoint discovered | https://docs.celo.org/build/agents/x402-get-discovered |
| MPP: Machine Payments Protocol | https://docs.celo.org/build/agents/mpp |
| Celopedia | https://docs.celo.org/build/agents/celopedia |
| Vibe Coding | https://docs.celo.org/build/agents/vibe-coding |
| MCP Overview | https://docs.celo.org/build/agents/mcp/index |
| Celo MCP Server | https://docs.celo.org/build/agents/mcp/celo-mcp |
| Celina | https://docs.celo.org/build/agents/mcp/celina |
| AI Agent Examples | https://docs.celo.org/build/agents/usecases |
| Attribution Tags | https://docs.celo.org/build/agents/attribution-tags |

> **New since the 2026-10-05 run: Agent Vault** (added 2026-10-15) — let an agent pay at online
> checkouts and sign in to websites via MCP server, SDK, or HTTP API, using mock tokens instead
> of real card numbers and passwords. The standalone "Agent Skills" page remains removed.

## Build — MiniPay

> **Consolidated.** The 5 separate pages this map previously tracked under
> `build-on-celo/build-on-minipay/*` (overview, quickstart, code-library, deeplinks, ngrok-setup)
> are gone — only a single overview page remains in the live sitemap. If you need the
> quickstart/code-library/deeplinks content, it likely now lives inline on this one page or has
> moved to `docs.minipay.xyz` exclusively (that source was blocked this run — see
> `minipay-docs-map.md`).

| Topic | URL |
|-------|-----|
| Build for MiniPay | https://docs.celo.org/build/mini-apps/overview |

## Fee Abstraction

| Topic | URL |
|-------|-----|
| Overview | https://docs.celo.org/build/fee-abstraction/overview |
| Using Fee Abstraction in Transactions | https://docs.celo.org/build/fee-abstraction/using-fee-abstraction |
| Adding Fee Currencies | https://docs.celo.org/build/fee-abstraction/add-fee-currency |

## Build — Tools: Dev Environments

> `tooling/dev-environments/*` → `build/tools/dev-environments/*`. Thirdweb's page flattened
> from `.../thirdweb/overview` to `.../thirdweb` (no more `/overview` suffix).

| Topic | URL |
|-------|-----|
| Build with Celo (overview) | https://docs.celo.org/build/tools/dev-environments/index |
| Foundry | https://docs.celo.org/build/tools/dev-environments/foundry |
| Hardhat | https://docs.celo.org/build/tools/dev-environments/hardhat |
| Remix | https://docs.celo.org/build/tools/dev-environments/remix |
| Thirdweb | https://docs.celo.org/build/tools/dev-environments/thirdweb |
| MultiBaas Overview (Curvegrid) | https://docs.celo.org/build/tools/dev-environments/multibaas/overview |
| MultiBaas Smart Contracts | https://docs.celo.org/build/tools/dev-environments/multibaas/contracts |
| MultiBaas Event Webhooks | https://docs.celo.org/build/tools/dev-environments/multibaas/webhooks |

## Build — Tools: Libraries & SDKs

> `tooling/libraries-sdks/*` → `build/tools/libraries-sdks/*`.

| Topic | URL |
|-------|-----|
| Celo SDKs Overview | https://docs.celo.org/build/tools/libraries-sdks/celo-sdks |
| Viem | https://docs.celo.org/build/tools/libraries-sdks/viem/index |
| Ethers.js | https://docs.celo.org/build/tools/libraries-sdks/ethers/index |
| Web3.js | https://docs.celo.org/build/tools/libraries-sdks/web3/index |
| ContractKit | https://docs.celo.org/build/tools/libraries-sdks/contractkit/index |
| ContractKit Setup | https://docs.celo.org/build/tools/libraries-sdks/contractkit/setup |
| ContractKit Usage | https://docs.celo.org/build/tools/libraries-sdks/contractkit/usage |
| ODIS (phone identifiers, PnP) | https://docs.celo.org/build/tools/libraries-sdks/contractkit/odis |
| Reown (WalletConnect) | https://docs.celo.org/build/tools/libraries-sdks/reown/index |
| Composer Kit UI | https://docs.celo.org/build/tools/libraries-sdks/composer-kit |
| Dynamic | https://docs.celo.org/build/tools/libraries-sdks/dynamic/index |
| JAW | https://docs.celo.org/build/tools/libraries-sdks/jaw/index |
| Portal | https://docs.celo.org/build/tools/libraries-sdks/portal/index |
| Celo CLI (overview) | https://docs.celo.org/build/tools/libraries-sdks/cli/index |
| Celo CLI — full commands reference | https://docs.celo.org/build/tools/libraries-sdks/cli/commands |

> The Celo CLI's per-subcommand reference (account, autocomplete, config, election, epochs,
> governance, help, identity, lockedcelo, multisig, network, node, oracle, plugins, releasecelo,
> rewards, transfer, validator, validatorgroup) lives under
> `build/tools/libraries-sdks/cli/<subcommand>` — see the commands reference page for the index.
> **"Thirdweb SDK" (previously `tooling/libraries-sdks/thirdweb-sdk/index`) no longer appears in
> the live sitemap at all — removed, not moved.** The Thirdweb dev-environment page above still
> covers using Thirdweb on Celo.

## Build — Tools: Contracts

> `tooling/contracts/*` → `build/tools/contracts/*`.

| Topic | URL |
|-------|-----|
| Core Contracts | https://docs.celo.org/build/tools/contracts/core-contracts |
| Stablecoin Contracts | https://docs.celo.org/build/tools/contracts/stablecoin-contracts |
| Fee Currencies | https://docs.celo.org/build/tools/contracts/fee-currencies |
| L1 Contracts | https://docs.celo.org/build/tools/contracts/l1-contracts |
| Uniswap Contracts | https://docs.celo.org/build/tools/contracts/uniswap-contracts |

## Build — Tools: Infrastructure

> `tooling/{nodes,oracles,indexers,explorers}/*` → `build/tools/{nodes,oracles,indexers,explorers}/*`.

| Topic | URL |
|-------|-----|
| Nodes & Services | https://docs.celo.org/build/tools/nodes/overview |
| Alchemy | https://docs.celo.org/build/tools/nodes/alchemy |
| Forno (Public RPC) | https://docs.celo.org/build/tools/nodes/forno |
| Oracles Overview | https://docs.celo.org/build/tools/oracles/index |
| Chainlink | https://docs.celo.org/build/tools/oracles/chainlink-oracles |
| Band Protocol | https://docs.celo.org/build/tools/oracles/band-protocol |
| RedStone | https://docs.celo.org/build/tools/oracles/redstone |
| Supra | https://docs.celo.org/build/tools/oracles/supra |
| Quex | https://docs.celo.org/build/tools/oracles/quex-oracles |
| DIA | https://docs.celo.org/build/tools/oracles/dia |
| Wit Oracle | https://docs.celo.org/build/tools/oracles/wit-oracle |
| Running Oracles | https://docs.celo.org/build/tools/oracles/run |
| Indexer Overview | https://docs.celo.org/build/tools/indexers/overview |
| The Graph | https://docs.celo.org/build/tools/indexers/the-graph |
| Envio | https://docs.celo.org/build/tools/indexers/envio |
| SubQuery | https://docs.celo.org/build/tools/indexers/subquery |
| GoldRush | https://docs.celo.org/build/tools/indexers/goldrush |
| Indexing Co | https://docs.celo.org/build/tools/indexers/indexing-co |
| Codex | https://docs.celo.org/build/tools/indexers/codex |
| Explorer Overview | https://docs.celo.org/build/tools/explorers/overview |
| Block Explorer (Celoscan + Blockscout) | https://docs.celo.org/build/tools/explorers/block-explorers |
| Analytics | https://docs.celo.org/build/tools/explorers/analytics |

## Build — Tools: Wallets

> `tooling/wallets/*` → `build/tools/wallets/*`.

| Topic | URL |
|-------|-----|
| Wallets Overview | https://docs.celo.org/build/tools/wallets/index |
| MetaMask and Celo | https://docs.celo.org/build/tools/wallets/metamask/use |
| Add Celo Testnet to MetaMask | https://docs.celo.org/build/tools/wallets/metamask/add-celo-testnet-to-metamask |
| MetaMask Programmatic Setup | https://docs.celo.org/build/tools/wallets/metamask/setup |
| Import Valora to MetaMask | https://docs.celo.org/build/tools/wallets/metamask/import |
| Ledger Setup | https://docs.celo.org/build/tools/wallets/ledger/setup |
| Connect Ledger to Celo Terminal | https://docs.celo.org/build/tools/wallets/ledger/to-celo-terminal |
| Connect Ledger to Celo Web Wallet | https://docs.celo.org/build/tools/wallets/ledger/to-celo-web |
| Connect Ledger to Celo CLI | https://docs.celo.org/build/tools/wallets/ledger/to-celo-cli |
| Ledger EIP-712 Signing Workaround | https://docs.celo.org/build/tools/wallets/ledger/eip712-workaround |

## Build — Tools: Other

> `tooling/{overview,testnets,contract-verification,bridges}/*` → `build/tools/{...}/*`.

| Topic | URL |
|-------|-----|
| Developer Tools Overview | https://docs.celo.org/build/tools/overview/index |
| Celo for Ethereum Developers | https://docs.celo.org/build/tools/overview/migrate/from-ethereum |
| Celo Sepolia Testnet | https://docs.celo.org/build/tools/testnets/celo-sepolia/index |
| Contract Verification Overview | https://docs.celo.org/build/tools/contract-verification/index |
| Verify with Hardhat | https://docs.celo.org/build/tools/contract-verification/hardhat |
| Verify with CeloScan | https://docs.celo.org/build/tools/contract-verification/celoscan |
| Verify with Blockscout | https://docs.celo.org/build/tools/contract-verification/blockscout |
| Verify with Remix | https://docs.celo.org/build/tools/contract-verification/remix |
| Bridging | https://docs.celo.org/build/tools/bridges/bridges |
| Cross-Chain Messaging | https://docs.celo.org/build/tools/bridges/cross-chain-messaging |

---

## Operate (Node Operators)

> `infra-partners/*` → `operate/*` (renamed 2026-08-24–09-10 run; stable since — unaffected by
> the 2026-10-06 Learn/Build rename). "Migrating a Celo L1 Node (legacy)" remains absent from
> the live sitemap.

| Topic | URL |
|-------|-----|
| Operate a Celo Node (index) | https://docs.celo.org/operate/index |
| Node Operators Overview | https://docs.celo.org/operate/operators/overview |
| Node Architecture | https://docs.celo.org/operate/operators/architecture |
| Running a Node with Docker | https://docs.celo.org/operate/operators/run-node |
| Running an Archive Node | https://docs.celo.org/operate/operators/archive-node |
| Serving Historical Proofs | https://docs.celo.org/operate/operators/historical-proofs |
| Running a Public RPC Node | https://docs.celo.org/operate/operators/public-rpc-node |
| Monitoring & Metrics | https://docs.celo.org/operate/operators/monitoring |
| Upgrades & Maintenance | https://docs.celo.org/operate/operators/maintenance |
| Troubleshooting | https://docs.celo.org/operate/operators/troubleshooting |
| Configuration Reference | https://docs.celo.org/operate/operators/configuration |
| Network Config & Assets | https://docs.celo.org/operate/operators/network-config |
| Cel2 FAQ | https://docs.celo.org/operate/operators/faq |

## Operate — Notices & Hardforks

| Topic | URL |
|-------|-----|
| Notices Overview | https://docs.celo.org/operate/notices/overview |
| End of Support for op-geth | https://docs.celo.org/operate/notices/op-geth-deprecation |
| Deprecation of Req/Res CL P2P Sync | https://docs.celo.org/operate/notices/req-resp-cl-sync-deprecation |
| L2 Migration (archive) | https://docs.celo.org/operate/notices/archive/l2-migration |
| Jello Hardfork — ZK (archive) | https://docs.celo.org/operate/notices/archive/jello-upgrade |
| Jovian Hardfork (archive) | https://docs.celo.org/operate/notices/archive/jovian-upgrade |
| Isthmus Hardfork (archive) | https://docs.celo.org/operate/notices/archive/isthmus-upgrade |
| Ice Cream Hardfork — EigenDA v2 (archive) | https://docs.celo.org/operate/notices/archive/eigenda-v2-upgrade |
| L1 Fusaka Upgrade (archive) | https://docs.celo.org/operate/notices/archive/l1-fusaka-upgrade |
| Celo Sepolia Launch (archive) | https://docs.celo.org/operate/notices/archive/celo-sepolia-launch |

## Operate — L2 Specification

| Topic | URL |
|-------|-----|
| Celo L2 Specification (index) | https://docs.celo.org/operate/specification/index |
| Deployments | https://docs.celo.org/operate/specification/deployments |
| Token Duality | https://docs.celo.org/operate/specification/token-duality |
| Transaction Fees | https://docs.celo.org/operate/specification/transaction-fees |
| Fee Abstraction (spec) | https://docs.celo.org/operate/specification/fee-abstraction |
| Transaction Types On Celo L2 | https://docs.celo.org/operate/specification/transaction-types |
| Native Bridge | https://docs.celo.org/operate/specification/native-bridge |
| EigenDA | https://docs.celo.org/operate/specification/eigenda |
| Finality | https://docs.celo.org/operate/specification/finality |
| L1 to L2 Migration | https://docs.celo.org/operate/specification/l2-migration |
| Smart Contract Updates From L1 | https://docs.celo.org/operate/specification/smart-contract-updates-from-l1 |
| L1 Deploy Verification | https://docs.celo.org/operate/specification/l1-smart-contract-verification |
| Jovian Upgrade | https://docs.celo.org/operate/specification/upgrades/jovian |
| Jello Upgrade | https://docs.celo.org/operate/specification/upgrades/jello |
| Ice Cream Upgrade | https://docs.celo.org/operate/specification/upgrades/ice-cream |
| Isthmus Upgrade | https://docs.celo.org/operate/specification/upgrades/isthmus |

---

## Contributing

> Two pages this map previously tracked — "Regional DAOs" (`contribute-to-celo/daos`) and
> "Attestation Service Release Process" (`contribute-to-celo/release-process/attestation-service`)
> — no longer appear in the live sitemap. Dropped below. "Code of Conduct" remains removed (first
> noted in an earlier run).

| Topic | URL |
|-------|-----|
| Joining Celo | https://docs.celo.org/contribute-to-celo/index |
| Builders | https://docs.celo.org/contribute-to-celo/builders |
| Contributor Overview | https://docs.celo.org/contribute-to-celo/contributors/overview |
| Code Contributors | https://docs.celo.org/contribute-to-celo/contributors/code-contributors |
| Community Improvement Proposals (CIP) Contributors | https://docs.celo.org/contribute-to-celo/contributors/cip-contributors |
| Documentation Contributors | https://docs.celo.org/contribute-to-celo/contributors/documentation-contributors |
| How Community RPC Providers Work | https://docs.celo.org/contribute-to-celo/community-rpc-nodes/how-it-works |
| Registering a Community RPC Provider | https://docs.celo.org/contribute-to-celo/community-rpc-nodes/registering-as-rpc-node |
| Operating a Community RPC Node | https://docs.celo.org/contribute-to-celo/community-rpc-nodes/community-rpc-node |
| Community RPC Provider Penalties | https://docs.celo.org/contribute-to-celo/community-rpc-nodes/penalties |
| Community RPC Provider FAQ | https://docs.celo.org/contribute-to-celo/community-rpc-nodes/validator-rpc-faq |
| Release Process Overview | https://docs.celo.org/contribute-to-celo/release-process/index |
| Smart Contracts Release Process | https://docs.celo.org/contribute-to-celo/release-process/smart-contracts |
| Blockchain Client Release Process | https://docs.celo.org/contribute-to-celo/release-process/blockchain-client |
| CLI/ContractKit Release Process | https://docs.celo.org/contribute-to-celo/release-process/base-cli-contractkit-dappkit-utils |

## Community Links

| Resource | URL |
|----------|-----|
| Website | https://celo.org |
| Discord | https://discord.com/invite/celo |
| Forum | https://forum.celo.org |
| Faucet | https://faucet.celo.org/celo-sepolia |
| FAQ | https://docs.celo.org/operate/operators/faq |

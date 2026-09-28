# Celo Documentation Map

> Source: https://docs.celo.org/llms.txt
> OpenAPI Spec: https://docs.celo.org/api-reference/openapi.json
> Last updated: 2026-09-28

Use this to find the right documentation page for any topic. Links go directly to docs.celo.org.

> **Major restructuring since the last check (2026-08-24 → 2026-09-28):** the site's operator/spec content moved wholesale from two separate trees to one. `infra-partners/*` (notices + node-operator guides) and the top-level `/specs/*` section **both** merged into a single new `/operate/*` tree: notices are now `operate/notices/*`, node-operator guides are `operate/operators/*`, and the L2 spec pages are `operate/specification/*`. The old paths still redirect (308), so existing links keep working, but the canonical sitemap only lists the new ones. Separately, the entire ~40-page **Legacy** tree (pre-L2 Proof-of-Stake/consensus docs) has been **replaced by a single page**, [`home/celo-l1`](https://docs.celo.org/home/celo-l1) — old `/legacy/*` URLs now redirect there (and `/legacy/faq` redirects to the new FAQ at `operate/operators/faq`). On MiniPay: the docs.celo.org copies of the MiniPay **Quickstart**, **Code Library**, **Deeplinks**, and **Ngrok Setup** pages are gone — all four now redirect to the single `build-on-minipay/overview` page, which points out to `docs.minipay.xyz` for everything else (see `minipay-docs-map.md`, the actual single source of truth for MiniPay dev docs). A new **Staking** subsection (7 pages) was also added under `home/protocol/staking/*`, previously undocumented here.

---

## Getting Started

| Topic | URL |
|-------|-----|
| What is Celo? | https://docs.celo.org/home/celo |
| Discover Celo | https://docs.celo.org/home/index |
| Our History | https://docs.celo.org/home/history |
| About Celo L1 (replaces the old Legacy tree) | https://docs.celo.org/home/celo-l1 |
| Quickstart | https://docs.celo.org/build-on-celo/quickstart |
| Building dApps on Celo | https://docs.celo.org/build-on-celo/index |
| Launch Checklist | https://docs.celo.org/build-on-celo/launch-checklist |
| Attribution Tags | https://docs.celo.org/build-on-celo/attribution-tags |
| Scaling Your App | https://docs.celo.org/build-on-celo/scaling-your-app |
| Network Information | https://docs.celo.org/build-on-celo/network-overview |
| L2 Architecture | https://docs.celo.org/build-on-celo/cel2-architecture |
| Fund your Project | https://docs.celo.org/build-on-celo/fund-your-project |
| Nightfall Privacy Layer | https://docs.celo.org/build-on-celo/nightfall |

> **Legacy tree consolidated.** The old ~40-page Legacy tree (Legacy Overview, Legacy L1 Architecture, Cel2 FAQ, What's Changed L1→L2, plus the pre-L2 Proof-of-Stake/consensus/validator-operations pages) is gone. All of it now redirects to the single **About Celo L1** page above. The Cel2 FAQ content lives at `operate/operators/faq` (see Operate a Celo Node, below).

## Build with AI

| Topic | URL |
|-------|-----|
| Overview | https://docs.celo.org/build-on-celo/build-with-ai/overview |
| Use Celo Docs with AI Tools | https://docs.celo.org/build-on-celo/build-with-ai/use-docs-with-ai |
| ERC-8004: Agent Trust Protocol | https://docs.celo.org/build-on-celo/build-with-ai/8004 |
| Self Agent ID: Proof-of-Human Identity for Agents | https://docs.celo.org/build-on-celo/build-with-ai/self-agent-id |
| x402: Agent Payments | https://docs.celo.org/build-on-celo/build-with-ai/x402 |
| MPP: Machine Payments Protocol | https://docs.celo.org/build-on-celo/build-with-ai/mpp |
| Celopedia | https://docs.celo.org/build-on-celo/build-with-ai/celopedia |
| MCP Overview | https://docs.celo.org/build-on-celo/build-with-ai/mcp/index |
| Celo MCP Server | https://docs.celo.org/build-on-celo/build-with-ai/mcp/celo-mcp |
| Celina (agent SDK/API/Telegram bot for Celo mainnet) | https://docs.celo.org/build-on-celo/build-with-ai/mcp/celina |
| AI Agent Examples | https://docs.celo.org/build-on-celo/build-with-ai/usecases |
| Vibe Coding | https://docs.celo.org/build-on-celo/build-with-ai/vibe-coding |

> New since the last check: **Self Agent ID** and **Celina** pages. Note: the standalone "Agent Skills" page (`build-with-ai/agent-skills`) is still removed from the live sitemap (redirects to the Celopedia page) — no longer link to it.

## Build for MiniPay

| Topic | URL |
|-------|-----|
| Overview (Celo-specific MiniPay basics + index into docs.minipay.xyz) | https://docs.celo.org/build-on-celo/build-on-minipay/overview |

> **The dedicated Quickstart, Code Library, Deeplinks, and Ngrok Setup pages under `build-on-celo/build-on-minipay/*` no longer exist in the sitemap** — all four now redirect (308) to the Overview page above. MiniPay's actual developer documentation (quickstart, guides, technical references, deeplinks) lives solely at `docs.minipay.xyz` from here on — see `minipay-docs-map.md` for that full index. Do not link to the old docs.celo.org sub-paths as if they were still distinct pages.

## Build with Ecosystem

| Topic | URL |
|-------|-----|
| Build with DeFi | https://docs.celo.org/build-on-celo/build-with-defi |
| Build with Farcaster | https://docs.celo.org/build-on-celo/build-with-farcaster |
| Build with Local Stablecoins | https://docs.celo.org/build-on-celo/build-with-local-stablecoin |
| Build with USA₮ | https://docs.celo.org/build-on-celo/build-with-usat |
| Build with Self (ZK Identity) | https://docs.celo.org/build-on-celo/build-with-self |
| Introduction to SocialConnect | https://docs.celo.org/build-on-celo/build-on-socialconnect |
| Nightfall Privacy Layer | https://docs.celo.org/build-on-celo/nightfall |

> New since the last check: **Build with USA₮** and **Introduction to SocialConnect** are now their own top-level pages.

## Fee Abstraction

| Topic | URL |
|-------|-----|
| Overview | https://docs.celo.org/build-on-celo/fee-abstraction/overview |
| Using Fee Abstraction in Transactions | https://docs.celo.org/build-on-celo/fee-abstraction/using-fee-abstraction |
| Adding Fee Currencies | https://docs.celo.org/build-on-celo/fee-abstraction/add-fee-currency |

## Protocol

| Topic | URL |
|-------|-----|
| Celo Protocol Overview | https://docs.celo.org/home/protocol/index |
| CELO Token Duality | https://docs.celo.org/home/protocol/celo-token |
| Metadata and Claims | https://docs.celo.org/home/protocol/metadata |
| Transactions Overview | https://docs.celo.org/home/protocol/transactions/overview |
| Transaction Types | https://docs.celo.org/home/protocol/transactions/transaction-types |
| Encrypted Payment Comments | https://docs.celo.org/home/protocol/transactions/tx-comment-encryption |
| Governance Overview | https://docs.celo.org/home/protocol/governance/overview |
| Create Governance Proposal | https://docs.celo.org/home/protocol/governance/create-governance-proposal |
| Governance Cheat Sheet | https://docs.celo.org/home/protocol/governance/governable-parameters |
| Governance Toolkit | https://docs.celo.org/home/protocol/governance/governance-toolkit |
| Voting in Governance (CLI) | https://docs.celo.org/home/protocol/governance/voting-in-governance |
| Voting with Mondo | https://docs.celo.org/home/protocol/governance/voting-in-governance-using-mondo |
| Smart Contract Upgrades | https://docs.celo.org/home/protocol/governance/smart-contracts-upgrades |
| Security Council | https://docs.celo.org/home/protocol/security-council |
| Challengers | https://docs.celo.org/home/protocol/challengers |
| Escrow | https://docs.celo.org/home/protocol/escrow |

> New since the last check: **Metadata and Claims** (connecting an account to off-chain identity via signed metadata files).

## Staking (new section)

> Entirely new subsection since the last check — not previously in this map.

| Topic | URL |
|-------|-----|
| Staking Overview | https://docs.celo.org/home/protocol/staking/index |
| Locked CELO | https://docs.celo.org/home/protocol/staking/locked-celo |
| Validator Elections | https://docs.celo.org/home/protocol/staking/validator-elections |
| Validator Groups | https://docs.celo.org/home/protocol/staking/validator-groups |
| Voting for Validator Groups | https://docs.celo.org/home/protocol/staking/voting |
| Key Management Summary | https://docs.celo.org/home/protocol/staking/key-management/summary |
| Detailed Role Descriptions | https://docs.celo.org/home/protocol/staking/key-management/detailed |
| Signer Key Rotation | https://docs.celo.org/home/protocol/staking/key-management/key-rotation |

## Epoch Rewards

| Topic | URL |
|-------|-----|
| L2 Epoch Rewards | https://docs.celo.org/home/protocol/epoch-rewards/index |
| Community Fund | https://docs.celo.org/home/protocol/epoch-rewards/community-fund |
| Carbon Offsetting Fund | https://docs.celo.org/home/protocol/epoch-rewards/carbon-offsetting-fund |

## Managing Assets

| Topic | URL |
|-------|-----|
| Wallets | https://docs.celo.org/home/wallets |
| Asset Management | https://docs.celo.org/home/manage/asset |
| Self-Custody | https://docs.celo.org/home/manage/self-custody |
| ReleaseGold | https://docs.celo.org/home/manage/release-gold |
| Gas Fees | https://docs.celo.org/home/gas-fees |
| Exchanges | https://docs.celo.org/home/exchanges |
| Ramps | https://docs.celo.org/home/ramps |
| Bridging | https://docs.celo.org/home/bridged-tokens/bridges |
| Bridging Native ETH | https://docs.celo.org/home/bridged-tokens/native-ETH-bridging |
| Bridging CELO from Ethereum | https://docs.celo.org/home/bridged-tokens/bridging-celo-from-ethereum |
| Withdrawing CELO to Ethereum | https://docs.celo.org/home/bridged-tokens/withdrawing-celo-to-ethereum |

> New since the last check: **Bridging CELO from Ethereum** and **Withdrawing CELO to Ethereum** — programmatic (viem/OP Stack) guides for the native bridge, alongside the existing UI-focused Bridging pages. "Exchange Assets" (`home/manage/exchange`) remains removed (redirects to `home/manage/asset`).

## Tooling — Overview

| Topic | URL |
|-------|-----|
| Developer Tools and Resources | https://docs.celo.org/tooling/overview/index |
| Celo for Ethereum Developers | https://docs.celo.org/tooling/overview/migrate/from-ethereum |

> New since the last check: **Celo for Ethereum Developers** (differences/similarities primer). Do not confuse with `migrating-from-another-chain.md` in this skill, which covers porting an app from another *Celo-like L2*, not from Ethereum.

## Tooling — Dev Environments

| Topic | URL |
|-------|-----|
| Build with Celo (overview) | https://docs.celo.org/tooling/dev-environments/index |
| Foundry | https://docs.celo.org/tooling/dev-environments/foundry |
| Hardhat | https://docs.celo.org/tooling/dev-environments/hardhat |
| Remix | https://docs.celo.org/tooling/dev-environments/remix |
| thirdweb | https://docs.celo.org/tooling/dev-environments/thirdweb |
| MultiBaas Overview (Curvegrid) | https://docs.celo.org/tooling/dev-environments/multibaas/overview |
| MultiBaas Smart Contracts | https://docs.celo.org/tooling/dev-environments/multibaas/contracts |
| MultiBaas Event Webhooks | https://docs.celo.org/tooling/dev-environments/multibaas/webhooks |

> **thirdweb consolidated.** The separate "Thirdweb Overview" (`dev-environments/thirdweb/overview`) and "Thirdweb SDK" (`libraries-sdks/thirdweb-sdk/index`) pages are gone — thirdweb is now a single page at `tooling/dev-environments/thirdweb`.

## Tooling — Libraries & SDKs

| Topic | URL |
|-------|-----|
| Celo SDKs Overview | https://docs.celo.org/tooling/libraries-sdks/celo-sdks |
| Viem | https://docs.celo.org/tooling/libraries-sdks/viem/index |
| Ethers.js | https://docs.celo.org/tooling/libraries-sdks/ethers/index |
| Web3.js | https://docs.celo.org/tooling/libraries-sdks/web3/index |
| ContractKit Overview | https://docs.celo.org/tooling/libraries-sdks/contractkit/index |
| ContractKit Setup | https://docs.celo.org/tooling/libraries-sdks/contractkit/setup |
| ContractKit Usage | https://docs.celo.org/tooling/libraries-sdks/contractkit/usage |
| Core Contracts (Wrapper/Registry) | https://docs.celo.org/tooling/libraries-sdks/contractkit/contracts-wrappers-registry |
| ODIS (phone identifiers, PnP) | https://docs.celo.org/tooling/libraries-sdks/contractkit/odis |
| Data Encryption Key | https://docs.celo.org/tooling/libraries-sdks/contractkit/data-encryption-key |
| Using Web3 from ContractKit | https://docs.celo.org/tooling/libraries-sdks/contractkit/notes-web3-with-contractkit |
| Migrating to viem | https://docs.celo.org/tooling/libraries-sdks/contractkit/migrating-to-viem |
| Migrating to ContractKit v2.0 | https://docs.celo.org/tooling/libraries-sdks/contractkit/migrating-to-contractkit-v2 |
| Migrating to ContractKit v1.0 | https://docs.celo.org/tooling/libraries-sdks/contractkit/migrating-to-contractkit-v1 |
| Reown (WalletConnect) | https://docs.celo.org/tooling/libraries-sdks/reown/index |
| Composer Kit UI | https://docs.celo.org/tooling/libraries-sdks/composer-kit |
| Dynamic | https://docs.celo.org/tooling/libraries-sdks/dynamic/index |
| Portal | https://docs.celo.org/tooling/libraries-sdks/portal/index |
| JAW | https://docs.celo.org/tooling/libraries-sdks/jaw/index |
| Celo CLI (overview) | https://docs.celo.org/tooling/libraries-sdks/cli/index |
| Celo CLI — full commands reference | https://docs.celo.org/tooling/libraries-sdks/cli/commands |

> The Celo CLI has a full per-subcommand reference under `tooling/libraries-sdks/cli/<subcommand>`: account, autocomplete, config, election, epochs, governance, help, identity, lockedcelo, multisig, network, node, oracle, plugins, releasecelo, rewards, transfer, validator, validatorgroup — see the commands reference page above for the full index. **Thirdweb SDK page removed** — see Tooling — Dev Environments.

## Tooling — Contracts

| Topic | URL |
|-------|-----|
| Core Contracts | https://docs.celo.org/tooling/contracts/core-contracts |
| Stablecoin Contracts | https://docs.celo.org/tooling/contracts/stablecoin-contracts |
| Fee Currencies | https://docs.celo.org/tooling/contracts/fee-currencies |
| L1 Contracts | https://docs.celo.org/tooling/contracts/l1-contracts |
| Uniswap Contracts | https://docs.celo.org/tooling/contracts/uniswap-contracts |

## Tooling — Infrastructure

| Topic | URL |
|-------|-----|
| Nodes & Services | https://docs.celo.org/tooling/nodes/overview |
| Forno (Public RPC) | https://docs.celo.org/tooling/nodes/forno |
| Alchemy | https://docs.celo.org/tooling/nodes/alchemy |
| Oracles Overview | https://docs.celo.org/tooling/oracles/index |
| Chainlink | https://docs.celo.org/tooling/oracles/chainlink-oracles |
| Band Protocol | https://docs.celo.org/tooling/oracles/band-protocol |
| RedStone | https://docs.celo.org/tooling/oracles/redstone |
| Supra | https://docs.celo.org/tooling/oracles/supra |
| Quex | https://docs.celo.org/tooling/oracles/quex-oracles |
| DIA | https://docs.celo.org/tooling/oracles/dia |
| Wit/Oracle (Witnet) | https://docs.celo.org/tooling/oracles/wit-oracle |
| Running Oracles | https://docs.celo.org/tooling/oracles/run |
| Indexer Overview | https://docs.celo.org/tooling/indexers/overview |
| The Graph | https://docs.celo.org/tooling/indexers/the-graph |
| Envio | https://docs.celo.org/tooling/indexers/envio |
| SubQuery | https://docs.celo.org/tooling/indexers/subquery |
| GoldRush | https://docs.celo.org/tooling/indexers/goldrush |
| Indexing Co | https://docs.celo.org/tooling/indexers/indexing-co |
| Codex | https://docs.celo.org/tooling/indexers/codex |
| Explorer Overview | https://docs.celo.org/tooling/explorers/overview |
| Block Explorer (Celoscan + Blockscout) | https://docs.celo.org/tooling/explorers/block-explorers |
| Analytics | https://docs.celo.org/tooling/explorers/analytics |

> New since the last check: **Wit/Oracle** (Witnet price feeds + on-chain randomness). The separate "Celoscan" and "Blockscout" pages remain merged into one Block Explorer page; the standalone "Faucet" and "Run a Node" tooling pages remain removed (faucet: use the Community Links entry below; run a node: see Operate a Celo Node).

## Tooling — Wallets

| Topic | URL |
|-------|-----|
| Wallets Overview | https://docs.celo.org/tooling/wallets/index |
| MetaMask and Celo | https://docs.celo.org/tooling/wallets/metamask/use |
| Add Celo Testnet to MetaMask | https://docs.celo.org/tooling/wallets/metamask/add-celo-testnet-to-metamask |
| MetaMask Programmatic Setup | https://docs.celo.org/tooling/wallets/metamask/setup |
| Import Valora to MetaMask | https://docs.celo.org/tooling/wallets/metamask/import |
| Ledger Setup | https://docs.celo.org/tooling/wallets/ledger/setup |
| Connect Ledger to Celo Terminal | https://docs.celo.org/tooling/wallets/ledger/to-celo-terminal |
| Connect Ledger to Celo Web Wallet | https://docs.celo.org/tooling/wallets/ledger/to-celo-web |
| Connect Ledger to Celo CLI | https://docs.celo.org/tooling/wallets/ledger/to-celo-cli |
| Ledger EIP-712 Signing Workaround | https://docs.celo.org/tooling/wallets/ledger/eip712-workaround |

> New since the last check: **Ledger EIP-712 Signing Workaround**.

## Tooling — Other

| Topic | URL |
|-------|-----|
| Celo Sepolia Testnet | https://docs.celo.org/tooling/testnets/celo-sepolia/index |
| Contract Verification Overview | https://docs.celo.org/tooling/contract-verification/index |
| Verify with Hardhat | https://docs.celo.org/tooling/contract-verification/hardhat |
| Verify with CeloScan | https://docs.celo.org/tooling/contract-verification/celoscan |
| Verify with Blockscout | https://docs.celo.org/tooling/contract-verification/blockscout |
| Verify with Remix | https://docs.celo.org/tooling/contract-verification/remix |
| Bridging | https://docs.celo.org/tooling/bridges/bridges |
| Cross-Chain Messaging | https://docs.celo.org/tooling/bridges/cross-chain-messaging |

## Contributing

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
| Attestation Service Release Process | https://docs.celo.org/contribute-to-celo/release-process/attestation-service |

> "Code of Conduct" (`contribute-to-celo/code-of-conduct`) remains removed from the live sitemap (redirects to `celo.org/code-of-conduct`). "Regional DAOs" (`contribute-to-celo/daos`) is no longer listed in the sitemap.

## Operate a Celo Node

> **Replaces both the old "Infrastructure Partners" / "Hardforks & Notices" sections (`infra-partners/*`) and the top-level "L2 Specs" section (`specs/*`).** Both trees were folded into this single `operate/*` tree. Old `infra-partners/*` and `specs/*` links still 308-redirect to the paths below, but the sitemap only lists the new ones.

| Topic | URL |
|-------|-----|
| Operate a Celo Node (index) | https://docs.celo.org/operate/index |
| Cel2 FAQ | https://docs.celo.org/operate/operators/faq |

### Notices

| Topic | URL |
|-------|-----|
| Network Notices Overview | https://docs.celo.org/operate/notices/overview |
| End of Support for op-geth | https://docs.celo.org/operate/notices/op-geth-deprecation |
| Deprecation of Req/Res CL P2P Sync | https://docs.celo.org/operate/notices/req-resp-cl-sync-deprecation |
| Jovian Hardfork (archive) | https://docs.celo.org/operate/notices/archive/jovian-upgrade |
| Jello Hardfork (archive) | https://docs.celo.org/operate/notices/archive/jello-upgrade |
| L1 Fusaka Upgrade (archive) | https://docs.celo.org/operate/notices/archive/l1-fusaka-upgrade |
| Celo Sepolia Testnet Launch (archive) | https://docs.celo.org/operate/notices/archive/celo-sepolia-launch |
| Ice Cream Hardfork — EigenDA v2 (archive) | https://docs.celo.org/operate/notices/archive/eigenda-v2-upgrade |
| L2 Isthmus Hardfork (archive) | https://docs.celo.org/operate/notices/archive/isthmus-upgrade |
| Celo L2 Migration (archive) | https://docs.celo.org/operate/notices/archive/l2-migration |

### Node Operators

| Topic | URL |
|-------|-----|
| Node Operators Overview | https://docs.celo.org/operate/operators/overview |
| Node Architecture | https://docs.celo.org/operate/operators/architecture |
| Running a Node with Docker | https://docs.celo.org/operate/operators/run-node |
| Running an Archive Node | https://docs.celo.org/operate/operators/archive-node |
| Serving Historical Proofs | https://docs.celo.org/operate/operators/historical-proofs |
| Running a Public RPC Node | https://docs.celo.org/operate/operators/public-rpc-node |
| Monitoring & Metrics | https://docs.celo.org/operate/operators/monitoring |
| Upgrades & Maintenance | https://docs.celo.org/operate/operators/maintenance |
| Troubleshooting | https://docs.celo.org/operate/operators/troubleshooting |
| Migrating a Celo L1 Node (legacy) | https://docs.celo.org/operate/operators/migrate-node |
| Configuration Reference | https://docs.celo.org/operate/operators/configuration |
| Network Config & Assets | https://docs.celo.org/operate/operators/network-config |

### L2 Specification

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

## Community Links

| Resource | URL |
|----------|-----|
| Website | https://celo.org |
| Discord | https://discord.com/invite/celo |
| Forum | https://forum.celo.org |
| Faucet | https://faucet.celo.org/celo-sepolia |
| FAQ | https://docs.celo.org/operate/operators/faq |

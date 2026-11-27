# ERC-8004 Validation Registry (preview)

> Source: `ValidationRegistryUpgradeable.sol` in github.com/erc-8004/erc-8004-contracts at `b9e466c`, and the ABI in that repo's `abis/ValidationRegistry.json`. Every function, event and revert string below was checked against the deployed Celo Mainnet implementation (selectors and topics in its bytecode; reverts by `eth_call` simulation) and the read examples were run on Celo Mainnet and Celo Sepolia.
> Last updated: 2026-11-27. The validation part of the spec is still being revised; re-check the contracts repo before quoting.

**No address here, on purpose.** The official contracts repo lists only the Identity and Reputation registries for Celo and marks the Validation section as still being revised (`ai-agents.md` → _Contract Deployments_). This file gives the interface and a way to **verify on-chain** whatever address a builder takes from that repo before building on it.

---

## What it is

The Identity Registry says *who* an agent is and the Reputation Registry collects *opinions* about it. The Validation Registry records *checks*: an agent's owner asks a named validator to verify a piece of work, and the validator posts a 0–100 result on-chain. A validator can be anything that signs a transaction: a service that re-runs the work, a staked re-executor, a zkML verifier, a TEE oracle. The registry judges nothing; it records who asked whom and what they answered.

## Interface

| Function | Who may call | Notes |
|---|---|---|
| `validationRequest(address validatorAddress, uint256 agentId, string requestURI, bytes32 requestHash)` | the agent's owner or an approved operator | Reverts `"bad validator"` for the zero address, `"exists"` if `requestHash` was used before (by anyone), `"Not authorized"` for any other caller |
| `validationResponse(bytes32 requestHash, uint8 response, string responseURI, bytes32 responseHash, string tag)` | only the validator named in the request | Reverts `"not validator"` for anyone else and `"resp>100"` above 100. Can be called again: the latest answer overwrites the earlier one and updates `lastUpdate` |
| `getValidationStatus(bytes32 requestHash)` | anyone | Returns `(validatorAddress, agentId, response, responseHash, tag, lastUpdate)`. Reverts `"unknown"` for a hash that was never requested |
| `getSummary(uint256 agentId, address[] validatorAddresses, string tag)` | anyone | Returns `(uint64 count, uint8 avgResponse)` over **answered** requests only; integer average; `""` = all tags; `[]` = all validators |
| `getAgentValidations(uint256 agentId)` | anyone | Every `requestHash` for an agent |
| `getValidatorRequests(address validatorAddress)` | anyone | Every `requestHash` sent to a validator |
| `getIdentityRegistry()` / `getVersion()` | anyone | The Identity Registry this deployment checks ownership against; the contract version (`2.0.0` on Celo today) |

Events: `ValidationRequest(address indexed validatorAddress, uint256 indexed agentId, string requestURI, bytes32 indexed requestHash)` and `ValidationResponse(address indexed validatorAddress, uint256 indexed agentId, bytes32 indexed requestHash, uint8 response, string responseURI, bytes32 responseHash, string tag)`.

`requestHash` should be `keccak256` of the exact bytes behind `requestURI` (the job to check), so the validator and anyone else can confirm they are looking at the same request. `responseHash` does the same for the validator's evidence behind `responseURI`.

## Verify the deployment first

A Validation Registry is only meaningful if it points at the Identity Registry your agents are registered in (`ai-agents.md` → _Contract Deployments_). Check that before trusting any address:

```typescript
import { createPublicClient, http, getAddress, parseAbi } from 'viem';
import { celo } from 'viem/chains';

export const validationRegistryAbi = parseAbi([
  'function validationRequest(address validatorAddress, uint256 agentId, string requestURI, bytes32 requestHash)',
  'function validationResponse(bytes32 requestHash, uint8 response, string responseURI, bytes32 responseHash, string tag)',
  'function getValidationStatus(bytes32 requestHash) view returns (address validatorAddress, uint256 agentId, uint8 response, bytes32 responseHash, string tag, uint256 lastUpdate)',
  'function getSummary(uint256 agentId, address[] validatorAddresses, string tag) view returns (uint64 count, uint8 avgResponse)',
  'function getAgentValidations(uint256 agentId) view returns (bytes32[])',
  'function getIdentityRegistry() view returns (address)',
  'function getVersion() view returns (string)',
]);

const IDENTITY_REGISTRY = '0x8004A169FB4a3325136EB29fA0ceB6D2e539a432'; // Celo Mainnet, ai-agents.md
const publicClient = createPublicClient({ chain: celo, transport: http('https://forno.celo.org') });

export async function verifyValidationRegistry(address: `0x${string}`) {
  const code = await publicClient.getCode({ address });
  if (!code || code === '0x') throw new Error('no contract at this address');
  const identity = await publicClient.readContract({ address, abi: validationRegistryAbi, functionName: 'getIdentityRegistry' });
  if (getAddress(identity) !== getAddress(IDENTITY_REGISTRY)) {
    throw new Error(`points at identity registry ${identity}, expected ${IDENTITY_REGISTRY}`);
  }
  return publicClient.readContract({ address, abi: validationRegistryAbi, functionName: 'getVersion' });
}
```

On Celo Sepolia use `celoSepolia`, `https://forno.celo-sepolia.celo-testnet.org` and the Sepolia Identity Registry from `ai-agents.md`.

## Request a validation (agent owner)

```typescript
import { keccak256, toBytes } from 'viem';

// 1. Publish the job somewhere the validator can read (https://, ipfs:// or a data: URI).
const job = JSON.stringify({
  agentId: '42',
  nonce: crypto.randomUUID(), // keeps requestHash unique (see Pitfalls)
  claim: { txHash: '0x...', minAmount: '10000' },
});
const requestURI = `data:application/json;base64,${Buffer.from(job).toString('base64')}`;
const requestHash = keccak256(toBytes(job));

// 2. Ask a validator. Sent by the agent's owner or an approved operator (walletClient with that account).
await walletClient.writeContract({
  address: VALIDATION_REGISTRY, // verified with verifyValidationRegistry()
  abi: validationRegistryAbi,
  functionName: 'validationRequest',
  args: [VALIDATOR_ADDRESS, 42n, requestURI, requestHash],
});
```

Which job format a validator accepts is up to that validator: read its documentation, for example the `services` in its own ERC-8004 registration file.

## Read results (anyone)

```typescript
// One request: who answered, what, and when.
const [validator, agentId, response, responseHash, tag, lastUpdate] = await publicClient.readContract({
  address: VALIDATION_REGISTRY, abi: validationRegistryAbi, functionName: 'getValidationStatus', args: [requestHash],
});

// Track record with the validators you trust, for one tag ('' = all tags).
const [count, avgResponse] = await publicClient.readContract({
  address: VALIDATION_REGISTRY, abi: validationRegistryAbi, functionName: 'getSummary', args: [42n, [VALIDATOR_ADDRESS], ''],
});
```

## Pitfalls

- **Pass the validators you trust** to `getSummary`. With `[]`, every validator counts, including one the agent's owner runs.
- **`getSummary` has no time window.** For freshness, check `lastUpdate` on the specific request.
- **Answers can be overwritten** by the same validator; re-read before acting on an old result.
- **Unanswered vs. failed:** the contract keeps a `hasResponse` flag but `getValidationStatus` doesn't return it, and `lastUpdate` is already set when the request is made. An unanswered request reads as `response = 0`, `responseHash = 0x0…0`. Treat a non-zero `responseHash` as "answered" only if the validator documents that it always posts one; otherwise look for its `ValidationResponse` event.
- **`requestHash` is global and first-come.** A second request with the same hash reverts `"exists"`, even from another agent. Put the `agentId` and a fresh nonce in the job so the hash is unique and can't be front-run from the mempool.
- **The owner chooses what to submit.** A high average shows the submitted claims checked out, not that every claim the agent made was checked.

## Related
- `ai-agents.md` — ERC-8004 registries, Contract Deployments, Metadata Compliance
- `self-agent-id.md` — proof-of-human on top of ERC-8004
- `agent-security.md` — permanent on-chain reputation and what an agent should never sign

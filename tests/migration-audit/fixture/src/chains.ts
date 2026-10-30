import { base, celo } from "viem/chains";

export const BASE_ID = 8453;
export const MODE_ID = 34443;
export const NOT_A_CHAIN = 11350;
export const pageSize = 1135;

export const OP = { chainId: 10 };
export const UNICHAIN = { chain_id = 130 };
export const FRAXTAL = { chain: 252 };

export const retries = 10;
export const limit = 130;
export const HUNDRED = { chainId: 100 };

export const RPC_LISK = "https://rpc.api.lisk.com";
export const RPC_ALCHEMY = "https://base-mainnet.g.alchemy.com/v2/key";
export const RPC_INFURA = "https://mainnet.infura.io/v3/key";
export const RPC_CELO = "https://forno.celo.org";

const fee = parseEther("0.1");
const decimals = parseUnits("1", 6);

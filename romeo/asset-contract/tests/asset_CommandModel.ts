// @ts-nocheck FIXME
import fc from "fast-check";

import { Simnet } from "@hirosystems/clarinet-sdk";

export type Stub = {
  wallets: Map<string, number>; // string: Address, number: Balance
  transactions: Tuple<string, number, Account>[]; // string: Id, number: Mint/Burn Amount, Account: Stacks Account
};

export type Real = {
  simnet: Simnet;
};

export type AssetCommand = fc.Command<Stub, Real>;

export interface BitcoinTxData {
  depositTx: Uint8Array;
  burnChainHeight: number;
  merkleProof: Uint8Array[];
  txIndex: number;
  treeDepth: number;
  blockHeader: Uint8Array;
  blockHeaderHash: Uint8Array;
}

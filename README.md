# On-chain Governance Aggregator (Snapshot-lite)

A professional-grade implementation for DAO coordination. This repository provides the core logic for proposal creation, voting, and execution. Unlike off-chain Snapshot voting, this contract records every vote on-chain, making it ideal for high-stakes treasury management where transparency and immutability are paramount.

## Core Features
* **Modular Voting Power:** Support for multi-asset voting (e.g., 1 Token = 1 Vote or 1 NFT = 100 Votes).
* **Quorum & Pass Thresholds:** Configurable logic to ensure decisions represent a significant portion of the community.
* **Timelock Integration:** Built-in delay between "Passed" and "Executed" to allow dissenting members to exit.
* **Flat Architecture:** Single-directory layout for the Governor, Voting Strategy, and Proposal Storage.



## Logic Flow
1. **Propose:** A member with sufficient balance submits a proposal and a target action.
2. **Vote:** Members cast For, Against, or Abstain votes during the voting window.
3. **Succeed:** If Quorum is met and For > Against, the proposal is marked as Succeeded.
4. **Execute:** After a mandatory waiting period, the proposal's transaction is executed by the contract.

## Setup
1. `npm install`
2. Deploy `GovernorAlpha.sol`.

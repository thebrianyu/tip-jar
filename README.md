# Tip Jar

A tip jar smart contract on Base Sepolia (a free test network) that anyone can pay into and only the owner can withdraw from, plus a one-page web app to use it. This is a learning project. See [SPEC.md](SPEC.md) for the full spec.

## Status

| Milestone | Status |
|---|---|
| 0. Setup | ✅ Done |
| 1. Contract | ✅ Done |
| 2. Tests | ✅ Done (7 passing) |
| 3. Deploy | ✅ Done |
| 4. Web page | ⬜ |
| 5. Review | ⬜ |

**Deployed contract (Base Sepolia, chain 84532):** [`0x7C1ACBfD4a2498a1aDae76aEc9193f6C13E25f28`](https://sepolia.basescan.org/address/0x7C1ACBfD4a2498a1aDae76aEc9193f6C13E25f28#code) (source verified on BaseScan)

- Owner: `0x73E37B2D7e9C439035c5421dbD793A792Af44fBc` (test-only wallet)
- Deploy transaction: [`0xbd8b99ab…5d64a0`](https://sepolia.basescan.org/tx/0xbd8b99abd7eba8fdcbb86da9d5eeea865f2fa78b52997d0f62e0b7130b5d64a0)

### Deploy it yourself

From `contracts/`, with `.env` filled in (`PRIVATE_KEY`, `BASE_SEPOLIA_RPC_URL`, `BASESCAN_API_KEY` — an Etherscan API key):

```bash
set -a && source ../.env && set +a
forge script script/DeployTipJar.s.sol --rpc-url base_sepolia                       # dry run: sends nothing
forge script script/DeployTipJar.s.sol --rpc-url base_sepolia --broadcast --verify  # real deploy + verify
```

## Repo layout

- `contracts/`: the Foundry project (Solidity contract, tests, deploy script)
- `web/`: the single web page (Milestone 4)
- `.env.example`: the settings you need, with blank values. Copy it to `.env` and fill it in.

## Setup

1. Install Foundry:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```
2. Clone this repo with its submodule (Foundry's `forge-std` test library):
   ```bash
   git clone --recurse-submodules https://github.com/thebrianyu/tip-jar.git
   ```
3. Copy the settings template and fill in a **test-only** wallet key:
   ```bash
   cp .env.example .env
   ```
   `.env` is in `.gitignore` and must never be committed.
4. Build and test:
   ```bash
   cd contracts && forge build && forge test
   ```
5. Get free Base Sepolia test ETH from a faucet (e.g. the Coinbase Developer Platform faucet). A faucet only ever needs your **address**, never your key.

## What I learned

### Milestone 0: Setup
- **Secrets stay out of git, and the guard goes up first.** `.gitignore` was written before the first commit, because git history is permanent. A key committed once is exposed forever, even if it's deleted later.
- **A wallet is just a private key.** It's 32 random bytes. The public address is derived from it by one-way math, so the address can be shared but the key must never be shown, typed into a website, or committed.
- **Test networks use free, valueless ETH.** Base Sepolia (chain ID 84532) lets us practice with faucet ETH. A faucet only needs the address. Anyone asking for a key is a scammer.
- **Dependencies are pinned.** Foundry's test library is included as a git submodule locked to an exact version (v1.17.0), so the project builds the same way everywhere.
- **Commits carry an identity.** Every commit records an author name and email, and both become public when pushed to a public repo.

### Milestone 1: Contract
- **Access control by hand.** The `onlyOwner` modifier compares `msg.sender` (whoever is calling) with the `owner` saved at deploy time, and rejects everyone else. `immutable` means the owner can never be changed.
- **Reject bad input early.** `tip()` reverts on zero ETH or a message over 140 bytes. A revert undoes the whole transaction and returns the sender's ETH.
- **Checks-effects-interactions.** `withdraw()` checks the caller first, records the event next, and sends ETH last. Sending ETH hands control to outside code, so all bookkeeping should already be finished.
- **Events are the contract's public log.** `TipReceived` and `Withdrawn` don't change any balances, but the web page will read them to show recent tips.
- **`view` functions only read.** `getBalance()` changes nothing, so calling it from outside costs no gas.

### Milestone 2: Tests
- **A test that has never failed proves nothing.** We broke the zero-tip check on purpose and watched `test_RevertWhen_TipIsZero` fail, then restored it and watched it pass.
- **Cheatcodes control the simulated chain.** `vm.prank` pretends to be a given wallet, `vm.deal` hands out fake ETH, and `vm.expectRevert` / `vm.expectEmit` say what must happen on the next call.
- **Check *why* something failed, not just *that* it failed.** The tests expect the specific error (`NotOwner`, `ZeroTip`, `MessageTooLong(141, 140)`), so a call that fails for the wrong reason doesn't count as a pass.
- **Test the edges.** Bugs cluster at boundaries, so we check 140 bytes (allowed) and 141 bytes (rejected).
- **Fresh state per test.** `setUp()` deploys a new jar before every test, so tests can't affect each other.

### Milestone 3: Deploy
- **Deploy with a script, and dry-run it first.** The same `forge script` command without `--broadcast` simulates the deploy and estimates the cost (~0.0000055 ETH). The real deploy cost ~0.0000023 ETH.
- **The deployer becomes the owner.** The constructor set `owner` to whichever wallet signed the deploy transaction, and `cast call ... owner()` confirms it on the live chain.
- **Verification proves the code is what we say it is.** BaseScan recompiled our source with the same pinned compiler (`solc 0.8.38`) and confirmed it matches the bytes on-chain, so anyone can read the real code.
- **Secrets travel through the environment, never through files we commit or text on screen.** The deploy script reads `PRIVATE_KEY` with `vm.envUint`, and the API key was pasted with `read -s` so it never displayed.
- **Deployment is permanent.** That's why the testing comes first.

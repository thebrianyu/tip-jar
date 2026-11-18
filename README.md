# Tip Jar

A tip jar smart contract on Base Sepolia (a free test network) that anyone can pay into and only the owner can withdraw from, plus a one-page web app to use it. This is a learning project. See [SPEC.md](SPEC.md) for the full spec.

## Status

| Milestone | Status |
|---|---|
| 0. Setup | ✅ Done |
| 1. Contract | ⬜ |
| 2. Tests | ⬜ |
| 3. Deploy | ⬜ |
| 4. Web page | ⬜ |
| 5. Review | ⬜ |

**Deployed contract address:** _not deployed yet (Milestone 3)_

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

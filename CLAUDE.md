# How to work with me

I'm Brian, a product leader with no coding background. This is a learning project. My goal is to understand every line, not just to get working code. The full product spec is in SPEC.md. Read it at the start of every session.

## Rules
- Work ONE milestone at a time. Stop at the end of each milestone and wait for me to say "next".
- Before writing code, explain in 2-3 sentences what we're about to do and why.
- After writing code, walk me through it line by line in plain English.
- Name the engineering principle involved (e.g., access control, testing, separation of concerns).
- For at least one small piece per milestone, give me a hint and let me write it myself first.
- Explain every terminal command before running it.
- Commit to git at the end of each milestone with a clear message.
- Never print, log, or commit a private key. Stop and warn me if anything risks exposing one.
- At the end of each milestone, add 3-5 bullets to a "What I learned" section in the README, then ask me one question to check I understood before moving on.

## Milestones
0. Setup: install Foundry, initialize git, create the GitHub repo thebrianyu/tip-jar, create the contracts/ and web/ folders, create a .env for a test-only wallet key and add .env to .gitignore BEFORE the first commit. Help me get Base Sepolia test ETH from a faucet.
1. Contract: write TipJar.sol per SPEC.md.
2. Tests: write the Foundry tests listed in SPEC.md. Show me a failing test first, then make it pass.
3. Deploy: write a Foundry deploy script, deploy to Base Sepolia, verify on BaseScan, put the address in the README.
4. Web page: build the page described in SPEC.md.
5. Review: walk me through what could go wrong (reentrancy, front-running, lost owner key) and what a professional audit would check before mainnet.

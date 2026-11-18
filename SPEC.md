# Tip Jar: Product Spec

## Goal
A tip jar smart contract on Base Sepolia that anyone can pay into and only the owner can withdraw from, plus a one-page web app to use it. The real goal is learning: I should be able to explain every line I ship.

## Success criteria
- I can explain what each line of the contract does and why.
- All tests pass, including tests proving a non-owner cannot withdraw.
- The contract is deployed and verified on Base Sepolia, viewable on BaseScan.
- A friend can open the web page, connect a wallet, and send a test tip.
- Every milestone is a separate commit in thebrianyu/tip-jar.

## Tooling
- Foundry for contracts, viem for the web page. No other libraries unless you explain why.
- Network: Base Sepolia (chain ID 84532).

## Contract (TipJar.sol, Solidity 0.8.x)
- owner: set to the deployer at deploy time.
- tip(string message): payable, anyone can call. Reject zero-value tips. Reject messages over 140 characters. Emit TipReceived(sender, amount, message).
- withdraw(): owner only. Send the full balance to the owner. Use checks-effects-interactions. Emit Withdrawn(amount).
- getBalance(): view, returns the balance.
- Write the owner check by hand (no OpenZeppelin) so I learn how it works.

## Tests (Foundry)
- A tip increases the balance by the tip amount.
- A zero-value tip reverts.
- TipReceived emits with the right sender, amount, and message.
- Owner can withdraw; balance goes to zero; owner receives the funds.
- A non-owner calling withdraw() reverts.
- A message over 140 characters reverts.

## Deployment
- Deploy with a Foundry script so it is repeatable.
- Use a fresh test-only wallet. Its private key lives in .env, which is in .gitignore and never committed.
- Verify on BaseScan. Record the deployed address in the README.

## Web page
- Single HTML page using viem.
- Connect wallet button (MetaMask or Coinbase Wallet). Prompt to switch to Base Sepolia if on the wrong network.
- Tip form: amount in ETH and optional message. Show pending, success, or error, with a BaseScan link.
- Show the current balance and the 10 most recent tips, read from events.
- Withdraw button visible only to the owner. The contract still enforces the rule; hiding the button is only for convenience.

## Out of scope
Mainnet, USDC, multiple owners, upgradeable contracts, public hosting.

## Repo structure
- contracts/ (Foundry project) and web/ (the page).
- README with setup steps, deployed address, and a "What I learned" log.

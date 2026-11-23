// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title TipJar
/// @notice Anyone can send a tip with a short message. Only the owner can withdraw.
contract TipJar {
    // ---------- State ----------

    /// The person who deployed the contract. Set once, can never change.
    address public immutable owner;

    /// Longest allowed message, measured in bytes (see note in tip()).
    uint256 public constant MAX_MESSAGE_LENGTH = 140;

    // ---------- Events (public log entries the web page will read) ----------

    event TipReceived(address indexed sender, uint256 amount, string message);
    event Withdrawn(uint256 amount);

    // ---------- Errors (named reasons a transaction is rejected) ----------

    error ZeroTip();
    error MessageTooLong(uint256 length, uint256 max);
    error NotOwner();
    error TransferFailed();

    // ---------- Access control ----------

    /// Runs before any function marked `onlyOwner`. Written by hand, no library.
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // ---------- Setup ----------

    constructor() {
        owner = msg.sender;
    }

    // ---------- Actions ----------

    /// Send ETH along with an optional message (up to 140 bytes).
    function tip(string calldata message) external payable {
        if (msg.value == 0) revert ZeroTip();

        // Note: this counts bytes, not visible characters. Plain English letters
        // are 1 byte each; an emoji is up to 4. Counting true characters on-chain
        // is expensive, so bytes is the standard, safe choice.
        uint256 length = bytes(message).length;
        if (length > MAX_MESSAGE_LENGTH) revert MessageTooLong(length, MAX_MESSAGE_LENGTH);

        emit TipReceived(msg.sender, msg.value, message);
    }

    /// Send the entire balance to the owner.
    /// Follows checks-effects-interactions:
    ///   1. Checks:       onlyOwner (who is calling?)
    ///   2. Effects:      read the amount and record the event
    ///   3. Interactions: send ETH out, last
    function withdraw() external onlyOwner {
        uint256 amount = address(this).balance;
        emit Withdrawn(amount);

        (bool ok, ) = owner.call{value: amount}("");
        if (!ok) revert TransferFailed();
    }

    // ---------- Reads ----------

    /// How much ETH the contract is holding right now (in wei).
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

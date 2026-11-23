// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {TipJar} from "../src/TipJar.sol";

contract TipJarTest is Test {
    TipJar jar;

    // Fake wallets for the tests. makeAddr turns a label into a fixed address.
    address owner = makeAddr("owner");
    address tipper = makeAddr("tipper");
    address stranger = makeAddr("stranger");

    // Runs before EVERY test, so each test starts from a fresh, identical jar.
    function setUp() public {
        vm.prank(owner); // the next call comes from `owner`...
        jar = new TipJar(); // ...so `owner` deploys the jar and becomes its owner
        vm.deal(tipper, 10 ether); // give the tipper 10 fake ETH to spend
    }

    // Spec: a tip increases the balance by the tip amount.
    function test_TipIncreasesBalance() public {
        vm.prank(tipper);
        jar.tip{value: 1 ether}("thanks!");

        assertEq(jar.getBalance(), 1 ether);
    }

    // Spec: a zero-value tip reverts.
    function test_RevertWhen_TipIsZero() public {
        vm.prank(tipper);
        vm.expectRevert(TipJar.ZeroTip.selector);
        jar.tip{value: 0}("free advice");
    }

    // Spec: TipReceived emits with the right sender, amount, and message.
    function test_TipEmitsTipReceived() public {
        vm.expectEmit(address(jar)); // "the next thing jar emits should match..."
        emit TipJar.TipReceived(tipper, 1 ether, "great work"); // "...this"

        vm.prank(tipper);
        jar.tip{value: 1 ether}("great work");
    }

    // Spec: owner can withdraw; balance goes to zero; owner receives the funds.
    function test_OwnerCanWithdraw() public {
        vm.prank(tipper);
        jar.tip{value: 2 ether}("");
        uint256 ownerBalanceBefore = owner.balance;

        vm.prank(owner);
        jar.withdraw();

        assertEq(jar.getBalance(), 0);
        assertEq(owner.balance, ownerBalanceBefore + 2 ether);
    }

    // Spec: a non-owner calling withdraw() reverts.
    function test_RevertWhen_NonOwnerWithdraws() public {
        vm.prank(tipper);
        jar.tip{value: 1 ether}("");

        vm.prank(stranger);
        vm.expectRevert(TipJar.NotOwner.selector);
        jar.withdraw();

        assertEq(jar.getBalance(), 1 ether); // the ETH is still in the jar
    }

    // Edge case: a message of exactly 140 bytes is allowed (the limit is "over 140").
    function test_MessageOfExactly140IsAllowed() public {
        string memory maxMessage = string(new bytes(140));

        vm.prank(tipper);
        jar.tip{value: 1 ether}(maxMessage);

        assertEq(jar.getBalance(), 1 ether);
    }

    // Spec: a message over 140 characters reverts.
    function test_RevertWhen_MessageTooLong() public {
        string memory longMessage = string(new bytes(141));

        vm.prank(tipper);
        vm.expectRevert(abi.encodeWithSelector(TipJar.MessageTooLong.selector, 141, 140));
        jar.tip{value: 1 ether}(longMessage);
    }
}

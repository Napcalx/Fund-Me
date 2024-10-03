// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundMe.sol";
import {fundMeS} from "../../script/fundMeS.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    fundMeS fundMes;

    address Cal = makeAddr("Cal");
    uint256 constant SENT_AMOUNT = 0.1 ether;
    uint256 constant INIT_BALANCE = 10 ether;

    // uint256 constant GAS_PRICE = 1;

    function setUp() external {
        fundMes = new fundMeS();
        fundMe = fundMes.run();
        vm.deal(Cal, INIT_BALANCE);
    }

    function testUserFundAndOwnerWithdraw() public {
        uint256 preUserBalance = address(Cal).balance;
        uint256 preOwnerBalance = address(fundMe.getOwner()).balance;

        // using Vm.prank to simulate funding from the Users address
        vm.prank(Cal);
        fundMe.fund{value: SENT_AMOUNT}();

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        uint256 afterUserBalance = address(Cal).balance;
        uint256 afterOwnerBalacne = address(fundMe.getOwner()).balance;

        assert(address(fundMe).balance == 0);
        assertEq(afterUserBalance + SENT_AMOUNT, preUserBalance);
        // assertEq(afterOwnerBalacne + SENT_AMOUNT, preOwnerBalance);
    }
}

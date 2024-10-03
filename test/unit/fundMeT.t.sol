// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundMe.sol";
import {fundMeS} from "../../script/fundMeS.s.sol";

contract fundMeT is Test {
    FundMe fundMe;
    address Cal = makeAddr("Cal");
    uint256 constant SENT_AMOUNT = 0.09 ether;
    uint256 constant INIT_BALANCE = 100 ether;
    uint256 constant GAS_PRICE = 1;

    //uint256 number = 10;
    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        fundMeS fundMes = new fundMeS();
        fundMe = fundMes.run();
        vm.deal(Cal, INIT_BALANCE);
    }

    function testMinimumUSD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwner() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testgetVersion() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFails() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesDataStruct() public {
        vm.prank(Cal); // The next TX would be done by Cal
        fundMe.fund{value: SENT_AMOUNT}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(Cal);
        assertEq(amountFunded, SENT_AMOUNT);
    }

    function testAddFunderToFundersArray() public {
        vm.prank(Cal);
        fundMe.fund{value: SENT_AMOUNT}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, Cal);
    }

    modifier funded() {
        vm.prank(Cal);
        fundMe.fund{value: SENT_AMOUNT}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(Cal);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        // Arrange

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingOwnerBalance + startingFundMeBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawWithMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank create new address
            // vm.deal fund new address
            // address()
            hoax(address(i), SENT_AMOUNT);
            fundMe.fund{value: SENT_AMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + startingFundMeBalance ==
                fundMe.getOwner().balance
        );
    }

    function testWithdrawWithMultipleFundersCheaper() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank create new address
            // vm.deal fund new address
            // address()
            hoax(address(i), SENT_AMOUNT);
            fundMe.fund{value: SENT_AMOUNT}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdrawCheaper();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            startingOwnerBalance + startingFundMeBalance ==
                fundMe.getOwner().balance
        );
    }
}

// console.log(number);
// console.log("Today is a new Day");
//assertEq(number, 2);

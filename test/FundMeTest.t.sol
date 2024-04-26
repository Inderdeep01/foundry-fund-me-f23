// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundMe;

    address private USR = makeAddr("usr");
    uint256 constant SEND_VAL = 2 ether;
    uint256 constant STARTING_BAL = 10 ether;

    modifier funded {
        vm.prank(USR);
        fundMe.fund{value: SEND_VAL}();
        _;
    }

    // this will run first
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USR, STARTING_BAL);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view{
        assertEq(fundMe.getOwner(), msg.sender);
        // assertNotEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USR);
        fundMe.fund{value: SEND_VAL}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USR);
        assertEq(amountFunded, SEND_VAL);
    }

    function testAddsFunderToArrayFunders() public {
        vm.prank(USR);
        fundMe.fund{value: SEND_VAL}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USR);
    }
 
    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USR);
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        
        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawWithMultipleFunders() public funded() {
        // Arrange
        uint160 numFunders = 10;
        uint160 funderIndex = 1;
        for (uint160 i = funderIndex; i< numFunders; i++){
            hoax(address(i), SEND_VAL);
            fundMe.fund{ value: SEND_VAL }();
        }

        uint256 startOwnerBalance = fundMe.getOwner().balance;
        uint256 startFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(startOwnerBalance + startFundMeBalance == fundMe.getOwner().balance);
    }
}
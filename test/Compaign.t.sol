// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/Test.sol";
import {Compaign} from "../src/Compaign.sol";
import {BaseTest} from "./BaseTest.sol";

contract CompaignTest is BaseTest {
    function setUp() public override {
        super.setUp();
    }

    function test_contract_deployed() public {
        console.log("Manager Address: ", manager);
        vm.startPrank(manager);
        assertEq(compaign.manager(), manager);
        console.log("Compaign Address: ", address(compaign));
        console.log("Minimum Contribution: ", compaign.minimumContribution());
        console.log("Compaign Manager: ", compaign.manager());
        assertEq(compaign.minimumContribution(), minimumContribution);
        vm.stopPrank();
    }

    function test_contribute() public payable {
        vm.deal(contributor1Address, 1 ether);
        vm.startPrank(contributor1Address);
        compaign.contribute{value: contributedAmount}(contributorName, contributorEmail);
        (address addr, string memory name, string memory email, uint256 amount) =
            compaign.approvers(contributor1Address);

        console.log("Contributor Address: ", addr);
        console.log("Contributor Name: ", name);
        console.log("Contributor Email: ", email);
        console.log("Contributor Amount: ", amount);
        assertEq(addr, contributor1Address);
        assertEq(name, contributorName);
        assertEq(email, contributorEmail);
        assertEq(amount, contributedAmount);
        vm.stopPrank();
    }

    function test_createRequest() public {
        vm.deal(manager, 10 ether);
        vm.startPrank(manager);
        compaign.createRequest("Buy a new laptop", 5 ether, vendorAddress);
        (string memory description, uint256 value, address recipient, bool complete, uint256 approvalCount) =
            compaign.getRequestDetails(0);
        assertEq(value, 5 ether);
        assertEq(approvalCount, 0);
        assertEq(complete, false);
        assertEq(recipient, vendorAddress);
        console.log("Request Description: ", description);
        console.log("Request Value: ", value);
        vm.stopPrank();
    }
}

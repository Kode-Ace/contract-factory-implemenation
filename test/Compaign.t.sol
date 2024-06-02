// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Compaign} from "../src/Compaign.sol";

contract CompaignTest is Test {
    Compaign public compaign;
    string public contributorName = "Omambia M";
    string public contributorEmail = "support@omambia.dev";
    address public manager = address(0x10000);
    address public contributor1Address = address(0x20001);
    address public contributorA2ddress = address(0x20002);
    address public vendorAddress = address(0x30000);
    uint256 public minimumContribution = 0.2 ether;
    uint256 public contributedAmount = 0.3 ether;

    function setUp() public {
        vm.deal(manager, 10 ether);
        vm.startPrank(manager);
        compaign = new Compaign(minimumContribution);
        vm.stopPrank();
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
        compaign.contribute{value: contributedAmount}(
            contributorName,
            contributorEmail
        );
        (
            address addr,
            string memory name,
            string memory email,
            uint256 amount
        ) = compaign.approvers(contributor1Address);

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
        (
            string memory description,
            uint256 value,
            address recipient,
            bool complete,
            uint256 approvalCount
        ) = compaign.getRequestDetails(0);
        assertEq(value, 5 ether);
        assertEq(approvalCount, 0);
        assertEq(complete, false);
        assertEq(recipient, vendorAddress);
        console.log("Request Description: ", description);
        console.log("Request Value: ", value);
        vm.stopPrank();
    }
}

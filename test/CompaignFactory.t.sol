// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CompaignFactory} from "../src/CompaignFactory.sol";
import {Compaign} from "../src/Compaign.sol";
import {BaseTest} from "./BaseTest.sol";

contract CompaignTest is BaseTest {
    function setUp() public override {
        super.setUp();
    }

    function test_createCompaign() public {
        vm.deal(manager, 10 ether);
        vm.startPrank(manager);
        factory.createCompaign(minimumContribution, compaignName, compaignDescription);
        vm.stopPrank();
        address[] memory compaigns = factory.getDeployedCompaigns();
        console.log("First Compaign: ", compaigns[0]);
        assertEq(compaigns.length, 1);
    }

    function test_compaign_create_listing_and_get_info() public {
        vm.deal(manager, 10 ether);
        vm.startPrank(manager);
        uint256 count = 5;
        for (uint256 i = 0; i < count; i++) {
            factory.createCompaign(
                minimumContribution,
                string(abi.encodePacked(i + 1, "-", compaignName)),
                string(abi.encodePacked(i + 1, "-", compaignDescription))
            );
        }
        vm.stopPrank();
        address[] memory compaigns = factory.getDeployedCompaigns();
        for (uint256 i = 0; i < compaigns.length; i++) {
            console.log("......................");
            Compaign compaign = Compaign(compaigns[i]);
            console.log("Compaign: ", compaign.name());
            console.log("Compaign Description: ", compaign.description());
            console.log("Compaign Manager: ", compaign.manager());
            console.log("Minimum Contribution: ", compaign.minimumContribution());
            console.log("Approver Count: ", compaign.approversCount());
            console.log("......................");
        }
        assertEq(compaigns.length, count);
    }
}

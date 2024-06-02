// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Compaign} from "../src/Compaign.sol";
import {CompaignFactory} from "../src/CompaignFactory.sol";

contract BaseTest is Test {
    // Compaign Factory contract
    CompaignFactory public factory;
    address public deployer = address(0x50000);
    // compaign contract
    Compaign public compaign;
    string public compaignName = "Create A trading Bot";
    string public compaignDescription = "Create a trading bot that can trade on ByBit to mine money";
    string public contributorName = "Omambia M";
    string public contributorEmail = "support@omambia.dev";
    address public manager = address(0x10000);
    address public contributor1Address = address(0x20001);
    address public contributorA2ddress = address(0x20002);
    address public vendorAddress = address(0x30000);
    uint256 public minimumContribution = 0.2 ether;
    uint256 public contributedAmount = 0.3 ether;

    function setUp() public virtual {
        // deploy the factory contract
        vm.deal(deployer, 10 ether);
        vm.startPrank(deployer);
        factory = new CompaignFactory();
        vm.stopPrank();
        // deploy the compaign contract
        vm.deal(manager, 10 ether);
        vm.startPrank(manager);
        compaign = new Compaign(minimumContribution, compaignName, compaignDescription, manager);
        vm.stopPrank();
    }
}

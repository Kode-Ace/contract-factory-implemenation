// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Compaign} from "../src/Compaign.sol";

contract CounterTest is Test {
    Compaign public compaign;
    uint256 public minimumContribution = 0.2 ether;

    function setUp() public {
        compaign = new Compaign(minimumContribution);
    }

    function test_contract_deployed() public view {
        assertEq(compaign.manager(), address(this));
        console.log("Compaign Address: ", address(compaign));
        console.log("Minimum Contribution: ", compaign.minimumContribution());
        console.log("Compaign Manager: ", compaign.manager());
        assertEq(compaign.minimumContribution(), minimumContribution);
    }
}

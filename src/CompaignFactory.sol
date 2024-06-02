// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Compaign} from "./Compaign.sol";

contract CompaignFactory {
    address[] public deployedCompaigns;
    address public deployer;

    constructor() {
        deployer = msg.sender;
    }

    function createCompaign(uint256 minimum, string memory name, string memory description) public {
        Compaign newCompaign = new Compaign(minimum, name, description, msg.sender);
        deployedCompaigns.push(address(newCompaign));
    }

    function getDeployedCompaigns() public view returns (address[] memory) {
        return deployedCompaigns;
    }
}

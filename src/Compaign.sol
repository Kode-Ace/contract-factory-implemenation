// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Compaign {
    address public manager;
    uint256 public minimumContribution;

    constructor(uint _minimum) public {
        manager = msg.sender;
        minimumContribution = _minimum;
    }
}

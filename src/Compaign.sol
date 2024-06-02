// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Compaign {
    struct Approver {
        address addr;
        string name;
        string email;
        uint256 amount;
    }

    struct Request {
        string description;
        uint256 value;
        address recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }

    address public manager;
    string public name;
    string public description;
    uint256 public minimumContribution;
    mapping(address => Approver) public approvers;
    Request[] public requests;
    uint256 public approversCount;

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call");
        _;
    }

    constructor(uint256 _minimum, string memory _name, string memory _description, address _creator) {
        manager = _creator;
        minimumContribution = _minimum;
        name = _name;
        description = _description;
    }

    function contribute(string memory _name, string memory _email) public payable {
        //  check if the minimum contribution is met
        require(msg.value > minimumContribution, "Minimum contribution not met");
        Approver memory _approver = Approver({addr: msg.sender, email: _email, name: _name, amount: msg.value});
        approvers[msg.sender] = _approver;
        approversCount++;
    }

    function createRequest(string memory _description, uint256 _value, address _recipient) public onlyManager {
        Request storage newRequest = requests.push();
        newRequest.description = _description;
        newRequest.value = _value;
        newRequest.recipient = _recipient;
        newRequest.complete = false;
        newRequest.approvalCount = 0;
    }

    function approveRequest(uint256 index) public {
        Request storage request = requests[index];
        require(approvers[msg.sender].amount > 0, "You are not a contributor");
        require(!request.approvals[msg.sender], "You have already approved this request");

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function getRequestDetails(uint256 index)
        public
        view
        returns (string memory _description, uint256 value, address recipient, bool complete, uint256 approvalCount)
    {
        Request storage request = requests[index];
        return (request.description, request.value, request.recipient, request.complete, request.approvalCount);
    }

    function finalizeRequest(uint256 index) public onlyManager {
        Request storage request = requests[index];
        require(!request.complete, "Request already completed");
        require(request.approvalCount > (approversCount / 2), "Approval count not met");
        payable(request.recipient).transfer(request.value);
        request.complete = true;
    }
}

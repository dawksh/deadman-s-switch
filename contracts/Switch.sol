// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Switch {

    modifier onlyOwner {
        require(msg.sender == owner, "Not Authorized for this");
        _;
    }

    uint256 public lastAlive;
    address public owner;
    address public authority;

    event AddedFunds (address sender, uint256 amount);

    constructor(address _authority) {
        owner = msg.sender;
        authority = _authority;
    }

    function still_alive() public onlyOwner {
        lastAlive = block.timestamp;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function updateAuthority(address newAuthority) public onlyOwner {
        authority = newAuthority;
    }

    function addFunds() public payable onlyOwner {
        emit AddedFunds(msg.sender, msg.value);
    }

    function getFunds() public {
        require(block.timestamp >= lastAlive + 10, "Time has not passed yet");
        payable(authority).transfer(address(this).balance);
    }

    receive() external payable {}
}
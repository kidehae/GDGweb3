// SPDX-License-Identifier: MIT

// pragma solidity ^0.8.17;

pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract ATM{
    address public owner;
    bool public paused;

    mapping (address => uint) private balances;

    constructor(){
        owner = msg.sender;
        paused = false;
    }

    // modifers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier whennotPaused() {
        require(!paused, "ATM is paused");
        _;
    }

    //deposit
    function deposit() public payable whennotPaused {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[msg.sender] += msg.value;
    }

    //withdraw
    function withdraw(uint amount) public whennotPaused {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    //check user balance
    function getbalance() public view returns(uint){
        return balances[msg.sender];
    }

    //check total ATM balance
    function getATMBalance() public view onlyOwner returns(uint){
        return address(this).balance;
    }
    
    // pause ATM(owner only)
    function pause() public onlyOwner {
        paused = true;
    }

    // unpause ATM(owner only)
    function unpause() public onlyOwner {
        paused = false;
    }
}
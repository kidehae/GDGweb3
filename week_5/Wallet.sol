// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Wallet {
    address public student;
    uint256 public balance;

    event Deposit(address indexed from, uint256 amount);
    event Withdraw(address indexed to, uint256 amount);

    modifier onlyStudent() {
        require(msg.sender == student, "Not the student");
        _;
    }

    constructor() {
        student = msg.sender;
    }

    // Deposit must be greater than 50 wei
    function deposit() public payable {
        require(msg.value > 50, "Deposit must be > 50");
        balance += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw (check non-zero student address)
    function withdraw(uint256 amount) public onlyStudent {
        require(student != address(0), "Invalid student address");
        require(amount <= balance, "Insufficient balance");

        balance -= amount;

        (bool success, ) = payable(student).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(student, amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
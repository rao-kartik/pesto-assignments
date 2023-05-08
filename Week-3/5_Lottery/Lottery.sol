// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    
    /* Declare State variables */
    address owner;
    address[] public participants;
    uint winningAmt;

    mapping(address => uint) public previousWinnersBal;
    
    /* Declare events */
    event winnerDecided (address indexed _winner);

    constructor() {
        // setting deployer as owner
        owner = msg.sender;
    }


    function enter() external payable {
        // setting a fee for entry
        require(msg.value == 0.1 ether, "Not a valid entry fee");

        participants.push(msg.sender);
        winningAmt += msg.value;
    }

    function claimReward() external {
        // checking if person claiming is the winner
        require(previousWinnersBal[msg.sender] != 0, "You are not the winner or you have already claimed the price");

        payable(msg.sender).transfer(previousWinnersBal[msg.sender]);
        delete previousWinnersBal[msg.sender];
    }
    
    function decideWinner() external {
        // checking if the owner is deciding the winner
        require(owner == msg.sender, "You are not authorised to make this call");
        // checking if participants are there or not
        require(participants.length > 0, "No participants");

        address winner = participants[random()];

        previousWinnersBal[winner] = winningAmt;
        
        emit winnerDecided(winner);

        participants = new address[](0);
        winningAmt = 0;
    }

    function random() private view returns(uint) {
        // Below function generates pseudorandom uint based on admin and block.timestamp
        return uint(keccak256(abi.encodePacked(owner, block.timestamp))) % participants.length - 1;
    }
}
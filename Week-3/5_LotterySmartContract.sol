// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    
    /* Declare State variables */
    address owner;
    address[] public participants;
    address public winner;
    bool public amountClaimed; // to check if amount is claimed or not

    mapping(address => bool) private ifParticipated;
    
    /* Declare events */
    event winnerDecided (address indexed _winner);

    constructor() {
        // setting deployer as owner
        owner = msg.sender;
    }


    function enter() external payable {
        // setting a fee for entry
        require(msg.value == 0.1 ether, "Not a valid entry fee");
        // checking if already participated
        require(!ifParticipated[msg.sender], "You have already entered the contest");

        participants.push(msg.sender);
        ifParticipated[msg.sender] = true;
    }

    function claimReward() external {
        // checking if winner declared
        require(winner != address(0), "Winner is not yet decided");
        // checking if amount claimed
        require(!amountClaimed, "Amount is Already claimed");
        // checking if person claiming is the winner
        require(winner == msg.sender, "You are not the winner");

        amountClaimed = true;
        payable(msg.sender).transfer(address(this).balance);
    }
    
    function decideWinner() external {
        // checking if the owner is deciding the winner
        require(owner == msg.sender, "You are not authorised to make this call");
        // checking if participants are there or not
        require(participants.length > 0, "No participants");
        // checking if winner is declared or not
        require(winner == address(0), "Winner is already declared");

        winner = participants[random()];
        emit winnerDecided(participants[random()]);
    }

    function random() private view returns(uint) {
        // Below function generates pseudorandom uint based on admin and block.timestamp
        return uint(keccak256(abi.encodePacked(owner, block.timestamp))) % participants.length - 1;
    }
}
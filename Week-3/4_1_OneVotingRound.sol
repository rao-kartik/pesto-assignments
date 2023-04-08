// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract oneVotingRound {
    address admin;
    bool votingInProgress;
    bool votingStopped;
    string[] votingSigns; // to loop through voting signs to finding winner

    struct Candidate {
        address addr;
        string votingSign;
        uint128 votes;
    }

    Candidate public winner;

    mapping(address => Candidate) CandidatesRecord; // to check if candidate is registered
    mapping(string => Candidate) VotingSignsUsed; //for storing voted & to check if voting sign is used or not
    mapping(address => bool) votersList; // to check if voters have voted or not

    // adding contract deployer as admin
    constructor() {
        admin = msg.sender;
    }

    function registerCandidate(string memory _votingSign) external {
        // Not allowing user to register if voting is started
        require(!votingInProgress, "You are late. Voting already started.");
        // Not allowing user to register if voting has stopped
        require(!votingStopped, "You are late. Voting is completed.");
        // checking if voting sign is entered or not
        require(bytes(_votingSign).length != 0, "Need a voting sign");
        // checking if candidate is registered or not
        require(CandidatesRecord[msg.sender].addr == address(0), "You are already registered.");
        // checking if voting sign is used or not
        require(VotingSignsUsed[_votingSign].addr == address(0), "Voting sign already used");

        Candidate memory newCandidate;
        newCandidate.addr = msg.sender;
        newCandidate.votingSign = _votingSign;

        VotingSignsUsed[_votingSign] = newCandidate;
        CandidatesRecord[msg.sender] = newCandidate;
        votingSigns.push(_votingSign);
    }

    function startVoting() external {
        // checking if voting has started or not
        require(!votingInProgress,"Voting already started");
        // checking if admin is starting voting
        require(admin == msg.sender, "You are not authorised to start voting");
        // checking if voting has stopped
        require(!votingStopped, "Voting is completed");
        // checking if min 1 candidate is registered
        require(votingSigns.length > 0, "No candidates registered");
        votingInProgress = true;
    }

    function stopVoting() external {
        // checking if voting has started or not
        require(votingInProgress, "Voting not yet started");
        // checking if voting has stopped
        require(!votingStopped, "Voting already stopped");
        // checking if admin is stopping voting
        require(admin == msg.sender, "You are not authorised to stop voting");
        votingInProgress = false;
        votingStopped = true;

        // finding winner
        winner = VotingSignsUsed[votingSigns[0]];

        for(uint64 i = 1; i < votingSigns.length; i++){
            if(VotingSignsUsed[votingSigns[i]].votes > winner.votes){
                winner = VotingSignsUsed[votingSigns[i]];
            }
        }
    }

    function vote(string memory _candidateVotingSign) external {
        // checking if voting has started
        require(votingInProgress, "Voting not yet started");
        // checking if voting has stopped
        require(!votingStopped, "Voting has been stopped");
        // checking if voting sign is entered
        require(bytes(_candidateVotingSign).length != 0, "Need candidate voting sign");
        // checking if voting sign is present
        require(VotingSignsUsed[_candidateVotingSign].addr != address(0), "Invalid candidate voting sign");
        // checking if already voted
        require(!votersList[msg.sender], "You have already voted");

        // setting true if voted
        votersList[msg.sender] = true;

        // vote
        VotingSignsUsed[_candidateVotingSign].votes = VotingSignsUsed[_candidateVotingSign].votes + 1;
    }
}
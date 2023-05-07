// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract oneVotingRound {
  address immutable admin;
  bool votingInProgress;
  bool votingStopped;
  uint128 totalRegisteredCandidates;

  address leadingCandidate;
  uint256 leadingCandidateVotes;

  struct Candidate {
    bool isRegistered;
    uint256 votes;
  }

  mapping(address => Candidate) CandidatesRecord; // to check if candidate is registered
  mapping(address => bool) hasVoted; // to check if voters have voted or not

  event DeclareWinner(address winner, uint256 votes);

  modifier checkVotingStarted() {
    // Not allowing user to register if voting is started
    require(!votingInProgress, "You are late. Voting already started.");
    _;
  }

  modifier checkVotingStopped(string memory _msg) {
    // Not allowing user to register if voting has stopped
    require(!votingStopped, _msg);
    _;
  }

  modifier isAdmin(string memory _msg) {
    require(admin == msg.sender, _msg);
    _;
  }

  // adding contract deployer as admin
  constructor() {
    admin = msg.sender;
  }

  function registerCandidate()
    external
    checkVotingStarted
    checkVotingStopped("You are late. Voting is completed.")
  {
    // checking if candidate is registered or not
    require(
      !CandidatesRecord[msg.sender].isRegistered,
      "You are already registered."
    );

    Candidate memory newCandidate;
    newCandidate.isRegistered = true;

    CandidatesRecord[msg.sender] = newCandidate;
    totalRegisteredCandidates += 1;
  }

  function startVoting()
    external
    isAdmin("You are not authorised to start voting")
    checkVotingStarted
    checkVotingStopped("Voting is completed.")
  {
    // checking if min 1 candidate is registered
    require(totalRegisteredCandidates > 1, "No candidates registered");
    votingInProgress = true;
  }

  function stopVoting()
    external
    isAdmin("You are not authorised to stop voting")
    checkVotingStopped("Voting already stopped")
  {
    // checking if voting has started or not
    require(votingInProgress, "Voting not yet started");
    votingInProgress = false;
    votingStopped = true;

    emit DeclareWinner(leadingCandidate, leadingCandidateVotes);
  }

  function vote(address _voteTo)
    external
    checkVotingStopped("Voting has been stopped")
  {
    // checking if voting has started
    require(votingInProgress, "Voting not yet started");
    // checking if voting sign is present
    require(_voteTo != address(0), "Invalid candidate voting sign");
    // checking if already voted
    require(!hasVoted[msg.sender], "You have already voted");

    // setting true if voted
    hasVoted[msg.sender] = true;

    // vote
    CandidatesRecord[_voteTo].votes += 1;

    if (CandidatesRecord[_voteTo].votes > leadingCandidateVotes) {
      leadingCandidate = _voteTo;
      leadingCandidateVotes = CandidatesRecord[_voteTo].votes;
    }
  }
}

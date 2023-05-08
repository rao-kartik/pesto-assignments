// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

/**
 * @title Voting
 * @author Kartik Yadav
 * @notice Contract to held a voting round
 */

contract MultipleVotingRounds {
  address immutable admin;

  struct VotingRound {
    bool votingStopped;
    bool votingInProgress;
    uint64 totalRegisteredCandidates;
    address leadingCandidate;
    uint256 leadingCandidateVotes;
  }

  struct Candidate {
    bool isRegistered;
    uint256 votes;
  }

  VotingRound[] public votingRounds;

  mapping(uint256 => mapping(address => bool)) hasVoted;
  mapping(uint256 => mapping(address => Candidate)) candidatesRecord;

  event DeclareWinner(uint256 _votingRound, address winner, uint256 votes);

  modifier _isValidRound(uint256 _votingRound) {
    require(_votingRound < votingRounds.length, "Voting Round not registered");
    _;
  }

  modifier _checkVotingStarted(uint256 _votingRound) {
    // Not allowing user to register if voting is started
    require(
      !votingRounds[_votingRound].votingInProgress,
      "You are late. Voting already started."
    );
    _;
  }

  modifier _checkVotingStopped(uint256 _votingRound, string memory _msg) {
    // Not allowing user to register if voting has stopped
    require(!votingRounds[_votingRound].votingStopped, _msg);
    _;
  }

  modifier _onlyAdmin(string memory _msg) {
    require(admin == msg.sender, _msg);
    _;
  }

  constructor() {
    admin = msg.sender;
  }

  function registerVotingRound()
    external
    _onlyAdmin("You are not authorised to start a voting round")
  {
    votingRounds.push(VotingRound(false, false, 0, address(0), 0));
  }

  function registerCandidate(uint256 _votingRound)
    external
    _isValidRound(_votingRound)
    _checkVotingStarted(_votingRound)
    _checkVotingStopped(_votingRound, "You are late. Voting is completed.")
  {
    // checking if candidate is registered or not
    require(
      !candidatesRecord[_votingRound][msg.sender].isRegistered,
      "You are already registered."
    );

    Candidate memory newCandidate;
    newCandidate.isRegistered = true;

    candidatesRecord[_votingRound][msg.sender] = newCandidate;

    votingRounds[_votingRound].totalRegisteredCandidates += 1;
  }

  function startVoting(uint256 _votingRound)
    external
    _isValidRound(_votingRound)
    _onlyAdmin("You are not authorised to start voting")
    _checkVotingStarted(_votingRound)
    _checkVotingStopped(_votingRound, "Voting is completed.")
  {
    // checking if min 1 candidate is registered
    require(
      votingRounds[_votingRound].totalRegisteredCandidates > 1,
      "No candidates registered"
    );
    votingRounds[_votingRound].votingInProgress = true;
  }

  function stopVoting(uint256 _votingRound)
    external
    _isValidRound(_votingRound)
    _onlyAdmin("You are not authorised to stop voting")
    _checkVotingStopped(_votingRound, "Voting already stopped")
  {
    // checking if voting has started or not
    require(
      votingRounds[_votingRound].votingInProgress,
      "Voting not yet started"
    );
    votingRounds[_votingRound].votingInProgress = false;
    votingRounds[_votingRound].votingStopped = true;

    emit DeclareWinner(
      _votingRound,
      votingRounds[_votingRound].leadingCandidate,
      votingRounds[_votingRound].leadingCandidateVotes
    );
  }

  function vote(uint256 _votingRound, address _voteTo)
    external
    _isValidRound(_votingRound)
    _checkVotingStopped(_votingRound, "Voting has been stopped")
  {
    // checking if voting has started
    require(
      votingRounds[_votingRound].votingInProgress,
      "Voting not yet started"
    );
    // checking if voting sign is present
    require(
      _voteTo != address(0) &&
        candidatesRecord[_votingRound][_voteTo].isRegistered,
      "Not a Registered Candidate"
    );
    // checking if already voted
    require(!hasVoted[_votingRound][msg.sender], "You have already voted");

    // setting true if voted
    hasVoted[_votingRound][msg.sender] = true;

    // vote
    candidatesRecord[_votingRound][_voteTo].votes += 1; 

    if (
      candidatesRecord[_votingRound][_voteTo].votes >
      votingRounds[_votingRound].leadingCandidateVotes
    ) {
      votingRounds[_votingRound].leadingCandidate = _voteTo;
      votingRounds[_votingRound].leadingCandidateVotes = candidatesRecord[
        _votingRound
      ][_voteTo].votes;
    }
  }
}

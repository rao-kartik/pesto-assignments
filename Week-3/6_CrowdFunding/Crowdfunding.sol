// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CrowdFunding {
  address owner;

  struct Project {
    address raisedFor;
    uint256 amountNeeded;
    uint256 fundingReceived;
    uint256 amountClaimed;
    bool completeAmountClaimed;
  }

  Project[] public allProjects;
  mapping(uint256 => mapping(address => uint256)) public contributors;

  modifier isProjectOwner(uint256 _projectId) {
    require(
      msg.sender == allProjects[_projectId].raisedFor,
      "Not a authorised user"
    );
    _;
  }

  modifier isValidProject(uint256 _projectId) {
    require(
      _projectId >= 0 && _projectId < allProjects.length,
      "Invalid project id"
    );
    _;
  }

  constructor() {
    owner = msg.sender;
  }

  function startNewProject(uint256 _amountNeeded) external {
    require(_amountNeeded > 0, "Invalied amount");

    Project memory newProject;

    newProject.amountNeeded = _amountNeeded;
    newProject.raisedFor = msg.sender;

    allProjects.push(newProject);
  }

  function contributeFunds(uint256 _projectId)
    external
    payable
    isValidProject(_projectId)
  {
    require(msg.value > 0, "Please enter a valid amount");

    Project memory requiredProject = allProjects[_projectId];

    require(
      requiredProject.amountNeeded - requiredProject.fundingReceived >= msg.value,
      "Not needed this much amount"
    );

    allProjects[_projectId].fundingReceived += msg.value;
    contributors[_projectId][msg.sender] += msg.value;
  }

  function claimFunds(uint256 _projectId, uint256 _amountToBeClaimed)
    external
    payable
    isValidProject(_projectId)
    isProjectOwner(_projectId)
  {
    Project memory requiredProject = allProjects[_projectId];
    require(!requiredProject.completeAmountClaimed, "Funds already claimed");

    require(
      _amountToBeClaimed <= requiredProject.fundingReceived,
      "Insufficient Funds"
    );

    (bool success, ) = requiredProject.raisedFor.call{
      value: _amountToBeClaimed
    }("");

    require(success, "Something went wrong. Please try after some time.");

    allProjects[_projectId].amountClaimed += _amountToBeClaimed;

    if (requiredProject.amountClaimed + _amountToBeClaimed == requiredProject.amountNeeded) {
      allProjects[_projectId].completeAmountClaimed = true;
    }
  }

  function withdrawFunds(uint256 _projectId, uint256 _amountToBeWithdrawn)
    external
    payable
    isValidProject(_projectId)
  {
    Project memory requiredProject = allProjects[_projectId];

    require(!requiredProject.completeAmountClaimed, "Funds have been claimed");

    require(
      _amountToBeWithdrawn > 0 &&
        requiredProject.fundingReceived - requiredProject.amountClaimed > 0 &&
        _amountToBeWithdrawn <=
        requiredProject.fundingReceived - requiredProject.amountClaimed &&
        _amountToBeWithdrawn <= contributors[_projectId][msg.sender],
      "Insufficient Balance"
    );

    (bool success, ) = msg.sender.call{value: _amountToBeWithdrawn}("");

    require(success, "Something went wrong. Please try after some time.");

    contributors[_projectId][msg.sender] -= _amountToBeWithdrawn;
    allProjects[_projectId].fundingReceived -= _amountToBeWithdrawn;
  }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Crowdfunding Contract
 * @author Kartik Yadav
 * @notice Contract to raise funds from public
 */
contract CrowdFunding {
  struct Project {
    address raisedFor;
    uint256 amountNeeded;
    uint256 fundingReceived;
    uint256 amountClaimed;
    bool completeAmountClaimed;
  }

  Project[] public allProjects;
  mapping(uint256 => mapping(address => uint256)) public contributors;

  /**
   * @notice modifier to check if the particular project was started by sender
   */
  modifier isProjectOwner(uint256 _projectId) {
    require(msg.sender == allProjects[_projectId].raisedFor, 'Not a authorised user');
    _;
  }

  /**
   * @notice modifier to check if the project exists or not
   */
  modifier isValidProject(uint256 _projectId) {
    require(_projectId >= 0 && _projectId < allProjects.length, 'Invalid project id');
    _;
  }

  /**
   * The function to start a new funding
   * @param _amountNeeded The amount that is to be raised
   */
  function startNewProject(uint256 _amountNeeded) external {
    require(_amountNeeded > 0, 'Invalied amount');

    Project memory newProject = Project({
      raisedFor: msg.sender,
      amountNeeded: _amountNeeded,
      fundingReceived: 0,
      amountClaimed: 0,
      completeAmountClaimed: false
    });

    allProjects.push(newProject);
  }

  /**
   * The function to contribute funds to a particular project
   * @param _projectId The id of the project you wanr to make donations to
   */
  function contributeFunds(uint256 _projectId) external payable isValidProject(_projectId) {
    require(msg.value > 0, 'Please enter a valid amount');

    Project memory requiredProject = allProjects[_projectId];

    require(
      requiredProject.amountNeeded - requiredProject.fundingReceived >= msg.value,
      'Not needed this much amount'
    );

    allProjects[_projectId].fundingReceived += msg.value;
    contributors[_projectId][msg.sender] += msg.value;
  }

  /**
   * The function to claim funds by the creator
   * @param _projectId The id of the project from which the claim is to be made
   * @param _amountToBeClaimed The amount that is to be claimed
   */
  function claimFunds(
    uint256 _projectId,
    uint256 _amountToBeClaimed
  ) external payable isValidProject(_projectId) isProjectOwner(_projectId) {
    Project memory requiredProject = allProjects[_projectId];
    require(!requiredProject.completeAmountClaimed, 'Funds already claimed');

    require(_amountToBeClaimed <= requiredProject.fundingReceived, 'Insufficient Funds');

    (bool success, ) = requiredProject.raisedFor.call{ value: _amountToBeClaimed }('');

    require(success, 'Something went wrong. Please try after some time.');

    allProjects[_projectId].amountClaimed += _amountToBeClaimed;

    if (requiredProject.amountClaimed + _amountToBeClaimed == requiredProject.amountNeeded) {
      allProjects[_projectId].completeAmountClaimed = true;
    }
  }

  /**
   *
   * @param _projectId The id of the project from  which the funds are to be withdrawn
   * @param _amountToBeWithdrawn The amount that is to be withdrawn
   */
  function withdrawFunds(
    uint256 _projectId,
    uint256 _amountToBeWithdrawn
  ) external payable isValidProject(_projectId) {
    Project memory requiredProject = allProjects[_projectId];

    require(!requiredProject.completeAmountClaimed, 'Funds have been claimed');

    // amount can be withdrawn only if the remaining amount in the project >= amount to be withdrawn
    require(
      _amountToBeWithdrawn <= requiredProject.fundingReceived - requiredProject.amountClaimed &&
        _amountToBeWithdrawn <= contributors[_projectId][msg.sender],
      'Insufficient Balance'
    );

    contributors[_projectId][msg.sender] -= _amountToBeWithdrawn;
    allProjects[_projectId].fundingReceived -= _amountToBeWithdrawn;

    (bool success, ) = msg.sender.call{ value: _amountToBeWithdrawn }('');

    if (!success) {
      contributors[_projectId][msg.sender] += _amountToBeWithdrawn;
      allProjects[_projectId].fundingReceived += _amountToBeWithdrawn;
    }

    require(success, 'Something went wrong. Please try after some time.');
  }
}

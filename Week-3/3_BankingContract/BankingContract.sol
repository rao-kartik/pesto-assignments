// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Banking Contract
 * @author Kartik Yadav
 * @notice Contract for banking system. User is able to deposit, check, withdraw and transfer their balance
 */

contract UserAccount {
  mapping(address => uint256) userRecords;

  /**
   * @custom:modifier to check if the contract has sufficient funds
   */
  modifier checkContractFunds(uint256 _amount) {
    require(
      address(this).balance >= _amount,
      "Contract doesn't have sufficient balance"
    );
    _;
  }

  /**
   * @notice add funds
   */
  function depositBal() external payable {
    require(msg.value > 0, "Invalid amount");

    userRecords[msg.sender] += msg.value;
  }

  /**
   * @notice check the balance of user in contract
   */
  function checkBalance() external view returns (uint256) {
    return userRecords[msg.sender];
  }

  /**
   * @notice to ithdrwa funds
   * @param _amount balance to withdraw
   */
  function withdrawFunds(uint256 _amount) external checkContractFunds(_amount) {
    // checking if user balance is sufficient or not
    require(userRecords[msg.sender] >= _amount, "Insufficient funds");
    userRecords[msg.sender] -= _amount;
    payable(msg.sender).transfer(_amount);
  }

  /**
   * @notice to transfer funds from one address to other within the contract
   * @param _address addressof the receiver
   * @param _amount balance to be transferred
   */
  function transferFunds(address _address, uint256 _amount)
    external
    checkContractFunds(_amount)
  {
    require(_address != address(0), "Invalid address");

    require(userRecords[msg.sender] >= _amount, "Insufficient funds");

    userRecords[msg.sender] -= _amount;

    // if reciever is in contract user records adding funds to the account
    userRecords[_address] += _amount;
  }
}

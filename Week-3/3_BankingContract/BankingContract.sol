// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract UserAccount {
    struct User {
        address userAddress;
        uint balance;
    }

    mapping (address => User) userRecords;

    modifier checkAuthorisation {
      User memory user = userRecords[msg.sender];
      require(user.userAddress != address(0), "Unauthorised user");
      _;
    }

    // with this function user can only deposit amount to its own account
    function depositBal() external payable {
        require(msg.value > 0, "Invalid amount");

        // checking if user is present in user Records
        User memory user = userRecords[msg.sender];
        if(user.userAddress == address(0)){
            // if not then creating a new user
            User memory newUser;
            newUser.userAddress = msg.sender;
            newUser.balance = msg.value;

            userRecords[msg.sender] = newUser;
        }else {
            // else adding funds to user account
            userRecords[msg.sender].balance = user.balance + msg.value;
        }
    }

    function checkBalance() external view checkAuthorisation returns(uint256) {
        User memory user = userRecords[msg.sender];
        return user.balance;
    }

    function withdrawFunds(uint _amount) external checkAuthorisation {
        // checking if contract balance is sufficient or not
        require(address(this).balance >= _amount, "Insufficient balance");
        User memory user = userRecords[msg.sender];
        // checking if user balance is sufficient or not
        require(user.balance >= _amount, "Insufficient funds");
        userRecords[msg.sender].balance = user.balance - _amount; 
        payable(msg.sender).transfer(_amount);
    }

    function transferFunds(address _address, uint256 _amount) external {
        require(_address != address(0), "Invalid address");
        require(_address != msg.sender, "Cannot transfer to self account");
        // checking if contract balance is sufficient or not
        require(address(this).balance >= _amount, "Insufficient funds");
        User memory sender = userRecords[msg.sender];
        require(sender.balance >= _amount, "Insufficient funds");

        // checking if _address is present in user records
        User memory receiver = userRecords[_address];
        require(receiver.userAddress != address(0), "Invalid address");
        userRecords[msg.sender].balance = sender.balance - _amount;

        // if reciever is in contract user records adding funds to the account
        userRecords[_address].balance = receiver.balance + _amount;
        
    }
}
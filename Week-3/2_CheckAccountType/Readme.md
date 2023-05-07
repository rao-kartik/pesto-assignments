# Write a small solidity function that - 

1. Accepts 1 address as argument 
2. Returns boolean False if that address is an EOA 
3. Returns TRUE if that address is a Contract

## Brief
Solved using two ways:

1. Using open zepplin library
2. using assembly extcodesize
    If its a contract the size will be greater than 0 and hence is a contract address else EOA

# Difference between Externally Owned Accounts (EOA) and Contract Accounts

1. EOAs are owned by the users while Smart contract are independent of addresses/accounts.
2. EOAs are controlled by the private key of the user while Smart Contracts are controlled by the compiler using the contract code.

# What is extcodesize?

Extcodesize is an opcode that returns the size of an account's code. It can be used to identify whether the account is an EOA or a contract account.

If the extcodesize is  > 0 then its a contract account.
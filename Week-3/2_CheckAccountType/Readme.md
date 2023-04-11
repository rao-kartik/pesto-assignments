# Write a small solidity function that - 

1. Accepts 1 address as argument 
2. Returns boolean False if that address is an EOA 
3. Returns TRUE if that address is a Contract

## Brief
Solved using two ways:

1. Using open zepplin library
2. using assembly extcodesize
    If its a contract the size will be greater than 0 and hence is a contract address else EOA
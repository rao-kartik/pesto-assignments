# Banking Contract

Design and implement a smart contract for a Banking system. The smart contract should allow users to:

1. Deposit funds into their account
2. Withdraw funds from their account
3. Transfer funds to other accounts
4. Check their account balance

### Requirements
1. The smart contract should have a function to deposit funds into the user's account
2. The smart contract should have a function to withdraw funds from the user's account
3. The smart contract should have a function to transfer funds from one account to another account
4. The smart contract shoul have a function to check the user's account balance
5. The smart contract should have a mapping to store the user's account balances
6. The smart contract should have proper error handling to prevent unauthorized access and to ensure that the user's funds are safe
7. The smart contract should be secure and have proper access control mechanisms
8. The smart contract should be thoroughly tested with different users and accounts

## Contract in brief

The contract has all functionalities mentioned above. The main features are:
1. Deposit funds
2. Withdraw funds
3. Transfer funds
4. Check account balance
5. Added a modifier to check check if user exists and if user exist only then he is able to check and withdraw funds
6. User can transfer funds only if he has sufficent balance and only the user can transfer funds from his account
7. User can't transfer funds to himself
8. Also checking if the receiver has account and only after verification the funds are transferred

# Lottery Smart Contract

### Requirements

1. Create a Lottery smart contract that allows multiple players to participate by sending ether to the contract (say 0.1 ETH)
2. The contract should choose a random player as the winner of the lottery and send the total money held by the contract to the winner
3. Only owner of the contract should be able to pick winner randlomly

4. Emit WinnerDecided event when the winner is chosen
5. Once the winner is decided by the contract, only winner of the lottery should be able to withdraw the money.
6. The contract should be able to display the list of all participants.
7. Once the winner is decided, owner should be able to reset the lottery and restart the game.

# Contract in brief
1. Player able to enter the game only after paying entry amount.
2. Only owner of contract able to decide the winner.
3. Player can enter multiple times to increase his chances of winning
4. Winner only decide by owner
5. winning balance can be claimed only by winner
6. resetting the lottery after winner is declared.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Contract to check if the address is of an EOA or a contract
 * @author Kartik Yadav
 * @notice This can be used to identify the type of account for a given address
 */

// import "@openzeppelin/contracts/utils/Address.sol";

// contract CheckAccount {
//     using Address for address;

//     function checkAccountType (address _addr) external view returns(string memory) {
//         if(_addr.isContract()){
//             return "Contract Account";
//         }
//         return "EOA";
//     }
// }

contract CheckAccount {
    function checkAccountType(
        address _addr
    ) external view returns (string memory) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }

        if (codeSize > 0) {
            return "Contract Account";
        }
        return "EOA";
    }`
}

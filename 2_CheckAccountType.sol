// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

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

    function checkAccountType (address _addr) external view returns(string memory) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }

        if(codeSize > 0){
            return "Contract Account";
        }
        return "EOA";
    }
}
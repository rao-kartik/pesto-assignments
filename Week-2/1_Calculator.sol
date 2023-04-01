// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Calculator {

    function addition (uint256 num1, uint256 num2) external pure returns(uint256) {
        return num1 + num2;
    }

    function subtraction (int256 num1, int256 num2) external pure returns(int256) {
        return num1 - num2;
    }

    function multiplication (uint256 num1, uint256 num2) external pure returns(uint256) {
        return num1 * num2;
    }

    function division (uint256 num1, uint256 num2) external pure returns(uint256) {
        return num1 / num2;
    }

    function modulo (uint256 num1, uint256 num2) external pure returns(uint256) {
        return num1 % num2;
    }
}
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Array {
    
    int[10] public arrayint=[int (42), -86, 69, 30, -85563];

    function get(uint8 index) public view returns (int256) {

        return arrayint[index];
    }

    function set(uint8 index, int256 value) public {
        arrayint[index]=value;
    }

}
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Map {

    mapping (address => uint) public myMap;
    function get(address key) public view returns (uint256) {
    return myMap[key];
    }

    function set(address key, uint256 value) public {
        myMap[key]=value;
    }

}
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Enum {
 enum MyEnum{ OWNER, CUSTOMER, FRIEND, DEVELOPER}
 mapping (address => MyEnum) public myMap;

    function getAddressType(address key) public view returns (MyEnum) {
    return myMap[key];
    }

    function setAddressType(address key, MyEnum value) public {
        myMap[key]=value;
    }
}
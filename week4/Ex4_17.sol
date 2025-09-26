// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex4_17 {
    uint public a = 4;
    
    function myFunc() public view returns(uint) {
        // a = 6;
        return a;
    }
}
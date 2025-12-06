// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ex4_02 {
    uint public a = 3; 
    function myFunc(uint b, uint c, uint d) public {
        a = b;
        a = c;
        a = d;
    }
}
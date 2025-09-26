// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
 
contract Ex4_05 {
    uint public a = 3;
    uint public b = myFunc();

    function myFunc() public returns(uint) {
        a = 100;
        return a;
    }
}
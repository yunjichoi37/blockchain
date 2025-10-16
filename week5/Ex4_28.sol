// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex4_28 {
    function fun1() public pure returns(uint) {
        uint result = 0;
        for (uint i = 0; i < 3; ++i) {
            result += i;
        }
        return result;
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex4_33 {
    function fun1() public pure returns(uint) {
        uint result = 0;
        
        for (uint a = 1; a < 3; ++a) {
            for (uint b = 2; b < 4; ++b) 
                result += (a*b);
        }
        return result;
    }
}
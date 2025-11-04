// SPDX-License-Identifier: GPL-3.0
// pragma solidity ^0.7.6;
pragma solidity >=0.7.0 < 0.9.0;

contract SimpleStorage {
    uint min = 0;
    uint max = 115792089237316195423570985008687907853269984665640564039457584007913129639935;

    function underflow() public view returns(uint) {
        return min - 1;
    }
    function overflow() public view returns(uint) {
        return max + 1;
    }
}
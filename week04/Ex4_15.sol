// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex4_15 {
    uint a = 3;
    // error: 함수 밖에 선언된 변수를 함수 내부에서 읽거나 변경할 수 없다.
    function myFunc() public pure returns(uint) {
        // a = 4;
        // return a;
    }
}
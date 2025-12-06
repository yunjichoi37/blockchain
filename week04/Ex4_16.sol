// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex4_16 {
    uint public a = 4;
    // view를 쓰면 함수 밖 변수를 읽을 수 있지만 변경은 불가하다.
    function myFunc() public view returns(uint) {
        uint b = a + 5;
        return b;
    }
}
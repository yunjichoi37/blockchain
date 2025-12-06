// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ex4_01 {
    // 상태 변수: 함수 밖에서 선언되어 블럭에 영원히 저장되는 변수
    uint public a = 3; 
    function myFunc() public {
        a = 5;
    }
}
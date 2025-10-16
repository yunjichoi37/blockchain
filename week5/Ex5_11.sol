// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// 생성자 constructor: smart contract가 생성/배포될 때 제일 먼저 한번 실행되는 함수이다.
// 배포 시 변수에 특정 값을 넣어준다.
contract Ex5_11 {
    uint public num = 5;

    constructor(uint _num) {
        num = _num;
    }
}
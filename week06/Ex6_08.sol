// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex6_08 {
    // 기본 0으로 초기화된다.
    uint public a;
    uint public b;

    // _ 위 코드가 먼저 실행되고, 함수의 로직을 실행한다.
    modifier plusA() {
        a += 1;
        _;
    }

    // 함수의 로직을 먼저 실행하고, _ 아래 코드가 실행된다.
    modifier plusB() {
        _;
        b += 1;
    }

    function mulA() public plusA() {
        a *= 2;
    }
    // plusA에 대해 여러 함수를 적용할 수 있다.
    function mulAAAA() public plusA() {
        a *= 123;
    }
    function mulB() public plusB() {
        b *= 2;
    }
}
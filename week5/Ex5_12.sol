// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex5_12 {
    // constant 선언 시 초기 값을 필수적으로 넣어줘야 한다.
    // uint public constant num1;
    // uint[] public immutable arr;

    // immutable은 필수로 넣어주지는 않음.
    uint public immutable num2;

    constructor(uint _num) {
        num2 = _num;
    }

    // 생성자에서 초기화할 수 있다.
    // function change() public pure returns(uint) {
    //     num2 = 10;
    // }
}
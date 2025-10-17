// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// 함수의 매개변수 개수나 자료형이 다르면 하나의 이름으로 사용할 수 있다.
contract Calculator {
    function mul(uint _num1, uint _num2) public pure returns(uint) {
        return _num1 * _num2;
    }
    function mul(uint _num1, uint _num2, uint _num3) public pure returns(uint) {
        return _num1 * _num2 * _num3;
    }
}

contract Ex6_03 {
    Calculator internal calculator = new Calculator();
    function getNumbers() public view returns(uint, uint) {
        return (calculator.mul(4, 5), calculator.mul(4, 5, 6));
    }
}
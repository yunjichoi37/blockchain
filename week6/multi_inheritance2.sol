// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// child에 parent의 함수와 변수가 있으면 안 된다.
// parent 사이에서도 함수와 변수의 중복이 없어야 한다.
contract ArtStudent {
    uint public times = 5;
    function time() public pure returns(uint) { }
}
contract PartTimer {
    // function time() public pure returns(uint) { }
}

contract Alice is ArtStudent, PartTimer {
    // uint public times = 2;
}
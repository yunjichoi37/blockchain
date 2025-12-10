// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// overriding
// child contract에서 parent의 함수를 덮어쓰기 해서 다른 동작을 실행하게 만들 수 있다.
// 이때 부모는 virtual, 자식은 override를 써줘야 한다.

contract Student {
    function major() public pure virtual returns(string memory) {
        return "Math";
    }
}

contract ArtStudent is Student {
    function major() public pure override returns(string memory) {
        return "Art";
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// 구현되지 않은 함수만 가진다.
// 이미 배포된 contract를 참조하고 호출할 때 유용하다.
// constructor 정의 X, 상태변수 X
// external이어야 한다.

interface System {
    function versionCheck() external returns(uint);
    function errorCheck() external returns(bool);
    function boot() external returns(uint, bool);
}

contract Computer is System {
    function versionCheck() public pure override returns(uint) {
        return 3;
    }
    function errorCheck() public pure override returns(bool) {
        return true;
    }
    function boot() public pure override returns(uint, bool) {
        return (versionCheck(), errorCheck());
    }
}

contract SmartPhone is System {
    function versionCheck() public pure override returns(uint) {
        return 25;
    }
    function errorCheck() public pure override returns(bool) {
        return true;
    }
    function boot() public pure override returns(uint, bool) {
        return (versionCheck(), errorCheck());
    }
}
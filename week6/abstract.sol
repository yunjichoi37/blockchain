// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// 함수의 구현 대신 선언만 가지는 contract
// 상속 받은 contract에서 구현해야 한다(virtual-override).
abstract contract System {
    uint internal version;
    bool internal errorPass;

    function versionCheck() internal virtual;
    function errorCheck() internal virtual;

    function boot() public returns(uint, bool) {
        versionCheck();
        errorCheck();
        return (version, errorPass);
    }
}

contract Computer is System {
    function versionCheck() internal override {
        version = 3;
    }
    function errorCheck() internal override {
        errorPass = true;
    }
}

contract SmartPhone is System {
    function versionCheck() internal override {
        version = 25;
    }
    function errorCheck() internal override {
        errorPass = false;
    }
}
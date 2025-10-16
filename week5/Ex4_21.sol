// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// 이렇게 하면 Deployed Contracts에서 funExt, funPub, pub 밖에 안 보인다.
contract Ex4_21 {
    uint public pub = 1;
    uint private pri = 2;
    uint internal inter = 3;
    // uint external ext = 4; // external은 변수에 사용할 수 없다.

    function funPub() public view returns(uint, uint, uint) {
        return (pub, pri, inter);
    }

    function funPriv() private view returns(uint, uint, uint) {
        return (pub, pri, inter);
    }

    function funInter() internal view returns(uint, uint, uint) {
        return (pub, pri, inter);
    }

    function funExt() external view returns(uint, uint, uint) {
        return (pub, pri, inter);
    }
}
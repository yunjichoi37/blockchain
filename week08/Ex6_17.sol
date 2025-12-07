// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex6_17 {
    // contract 배포하면서 넣어놓기.
    // constructor에 payable만 해주면 된다.
    // 그래서 Deploy 버튼이 빨간 색으로 뜸.
    
    constructor() payable { }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// msg.sender: address 자료형, 메시지 호출자
// msg.value: uint, wei 단위

// account를 바꾸고 getMsgValue를 누르면
// Ex6_12라는 contract에 돈이 들어온다.
// 돈을 보낸 account의 getBalance는 줄어들고,
// Ex6_12의 account의 getBalance는 늘어난다.
contract Ex6_12 {
    function getBalance(address _address) public view returns(uint) {
        return _address.balance;
    }
    function getMsgValue() public payable returns(uint) {
        return msg.value;
    }
    function getMsgSender() public view returns(address) {
        return msg.sender; // 함수 호출한 계정의 주소를 반환함
    }
}
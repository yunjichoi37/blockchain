// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex6_16 {
    event Obtain(address from, uint amount);

    // contract가 ether를 전송받을 수 있게 만드는 함수!! receive
    receive() external payable {
        emit Obtain(msg.sender, msg.value);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    function sendEther() public payable {
        payable(address(this)).transfer(msg.value);
    }
}
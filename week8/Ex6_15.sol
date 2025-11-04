// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex6_15 {
    function getBalance(address _address) public view returns(uint) {
        return _address.balance;
    }

    function ethDelivery(address _address) public payable {
        (bool result, ) = _address.call{value:msg.value, gas: 30000}("");
        require(result, "Failed");
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Math {
    uint result = 0;
    function add(uint256 _num1, uint256 _num2) public {
        result = _num1 + _num2;
    }
    function returnResult() public view returns(uint) {
        return result;
    }
}

// ABI encode로 byte 형태의 code를 만들어 냄.
// call과 함께 사용하여 호출할 수 있음.
// 띄어쓰기까지 없애야 한다.
contract Buttons {
    function addButtons(address _address, uint _num1, uint _num2) public {
        (bool success, ) = _address.call(
            abi.encodeWithSignature("add(uint256,uint256)", _num1, _num2)
        );
        require(success, "Failed");
    }

    function showResult(address _address) public returns(bytes memory) {
        (bool success, bytes memory result) = _address.call(
            abi.encodeWithSignature("returnResult()")
        );
        require(success, "Failed");
        return result;
    }
}
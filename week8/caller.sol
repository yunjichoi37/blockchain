// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Receiver {
    string lastFunctionCalled; // 마지막으로 호출된 함수명 저장

    fallback() external {
        lastFunctionCalled = "fallback()"; // 함수명 저장
    }
    function outPut() public payable {
        lastFunctionCalled = "outPut()";
    }
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    function getLastFunctionCalled() public view returns(string memory) {
        return lastFunctionCalled;
    }
}

contract Caller {
    function expectFallback(address _address) public {
        (bool success,) = _address.call(
            abi.encodeWithSignature("outPut2()")
        );
        require(success, "Failed");
    }

    function outPutWithEther(address _address) public payable {
        (bool success, ) = _address.call{value:msg.value}(
            abi.encodeWithSignature("outPut()")
        );
        require(success, "Failed");
    }
}

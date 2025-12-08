// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// try-catch는 external에만 사용할 수 있다.

contract Ex6_04 {
    event ErrorReason1(string reason);
    event ErrorReason2(uint errorCode);
    event ErrorReason3(bytes lowLevelData);

    function output5(uint _num) public pure returns(uint) {
        if (_num == 6) revert("_num should be 5"); // error 발생
        if (_num == 4) assert(false); // panic 발생
        return 5;
    }

    function output5WithTryCatch(uint _num) public returns(uint256, bool) {
        try this.output5(_num) returns(uint256 value){
            return(value, true);
        } catch Error(string memory reason) { // revert의 오류 메시지
            emit ErrorReason1(reason);
            return (0, false);
        } catch Panic(uint errorCode) {
            emit ErrorReason2(errorCode);
            return (0, false);
        } catch (bytes memory lowLevelData) {
            emit ErrorReason3(lowLevelData);
            return (0, false);
        }
    }
}
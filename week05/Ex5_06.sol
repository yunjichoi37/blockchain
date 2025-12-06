// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// pop(): 배열의 마지막 원소를 제거한다(크기도 줄어든다).
// delete: 배열의 크기는 줄지 않는다(0으로 초기화 되는 듯).
contract Ex5_06 {
    uint[] public array = [97, 98, 99];

    function getLength() public view returns(uint) {
        return array.length;
    }

    function popArray() public {
        array.pop();
    }
    function deleteArray(uint _index) public {
        delete array[_index];
    }
}
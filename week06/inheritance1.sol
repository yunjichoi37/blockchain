// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// inheritance: parent contract의 변수/함수를 child contract에서 사용할 수 있다.
// 이때, private는 제외한다.

contract Student {
    string public schoolName = "The University of Solidity";
}

// is를 통해 부모의 변수와 함수를 활용할 수 있다.
contract ArtStudent is Student {
    function changeSchoolName() public {
        schoolName = "The University of Blockchain";
    }
    function getSchoolName() public view returns(string memory) {
        return schoolName;
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex4_23 {
    // this를 이용해 external 함수 내부에 접근할 수 있다.
    
    function funExt() external pure returns(uint) {
        return 2;
    }
    function outPutExt() public view returns(uint) {
        return this.funExt();
    }
}
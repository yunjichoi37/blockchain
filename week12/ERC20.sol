// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract ERC20StdToken {
    mapping (address => uint256) balances; // 각 계정이 소유한 토큰 수
    mapping (address => mapping (address => uint256)) allowed; // 각 계정이 타 계정에 대리 전송할 수 있게 허용한 토큰 수

    uint256 private total; // 총 발행 토큰 수
    string name; // 토큰 이름
    string symbol; // 토큰 심볼
    uint public decimals; // 토큰 소수점 자리 수

    // indexed: event 필터링
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor (string memory _name, string memory _symbol, uint _totalSupply) {
        total = _totalSupply;
        name = _name;
        symbol = _symbol;
        decimals = 0;
        balances[msg.sender] = _totalSupply; // 전체 발행량을 배포자에게 지급하기
        emit Transfer(address(0x0), msg.sender, _totalSupply); // Transfer 이벤트 발생(msg.sender에게 _totalSupply 지급)
    }

    function totalSupply() public view returns(uint256) {
        return total; // 총 발행 토큰 수 반환
    }

    function balanceOf(address _owner) public view returns(uint256) {
        return balances[_owner]; // _owner가 가지고 있는 토큰 수 반환
    }

    function allowance(address _owner, address _spender) public view returns(uint remaining) {
        return allowed[_owner][_spender]; // owner(위임한 사람)가 spender(위임 받은 사람)에게 위임 허락한 토큰 수
    }

    function transfer(address _to, uint256 _value) public returns(bool success) {
        require(balances[msg.sender] >= _value, "not enough"); // 보내려는 대상(sender)의 balance가 value보다 큰지 확인한다.

        if ((balances[_to] + _value) >= balances[_to]) { // overflow 검사
            balances[msg.sender] -= _value; // from 잔액 value만큼 줄이기
            balances[_to] += _value; // to 잔액 value만큼 늘리기
            emit Transfer(msg.sender, _to, _value); // 이벤트 발생
            return true; // transfer 성공
        } else {
            return false; // transfer 실패
        }
    }

    // msg.sender가 spender에게 value만큼의 토큰 사용 권한 부여하기
    function approve(address _spender, uint _value) public returns(bool success) { 
        allowed[msg.sender][_spender] = _value; // msg.sender가 spender에게 허락한 토큰 지정해주기
        emit Approval(msg.sender, _spender, _value); // 위임 이벤트 발생
        return true; 
    }

    // 위임 전송
    function transferFrom(address _from, address _to , uint256 _value) public returns(bool success) {
        require(balances[_from] >= _value, "_From not enough"); // from(위임한 사람)의 토큰 양이 충분해야 함.
        require(allowed[_from][msg.sender] >= _value, "_from > msg.sender not enough"); // from이 msg.sender(위임 받은 사람)에게 지정한 값이 value보다 커야 함

        if ((balances[_to] + _value) >= balances[_to]) { // overflow 검사
            balances[_from] -= _value; // from(위임한 사람)의 토큰에서 value만큼 차감해야 한다.
            balances[_to] += _value; // 토큰을 받는 사람의 balances를 value만큼 올려줘야 한다.
            allowed[_from][msg.sender] -= _value; // from이 msg.sender에서 위임한 것에서 value만큼 빼줘야 한다.
            // A -(위임)-> B -(수행)-> C
            emit Transfer(_from, _to, _value); // from(A)이 to(C)에게 value만큼 보냈다.
            return true; // 성공
        } else {
            return false; // 실패
        }
    }
}
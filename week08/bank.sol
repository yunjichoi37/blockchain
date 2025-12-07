// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Bank {
    address public owner;                       // 은행장
    mapping(address => uint) public balances;   // 사용자별 주소, 잔고 매핑

    event Deposit(address _address, uint _value);       // deposit event: 누가 얼마를 입금했는지 기록
    event Withdrawal(address _address, uint _value);    // withdraw event: 누가 얼마를 출금했는지 기록

    constructor() { // contract 배포자를 owner로 설정해준다.
        owner = msg.sender;
    }

    modifier onlyOwner() { // owner만 호출을 허용하게 만들기 위해 사용한다.
        require(msg.sender == owner, "You're not the bank manager.");
        _;
    }

    function deposit() public payable {         // eth를 받을 수 있게 payable로 설정해준다.
        // require(amount > 0, "Deposit amount must be greater than 0.");
        balances[msg.sender] += msg.value;      // 입금자의 은행 잔고를 업데이트 한다.
        emit Deposit(msg.sender, msg.value);    // 이벤트를 발생시킨다.
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdrawal amount must be greater than 0."); // 출금 금액이 0보다 커야 한다(실제 은행 앱 참고).
        
        /*
            아래 require에서는 1 ether를 곱해야 한다.
            amount와만 비교하면, require로 인한 에러 메시지가 아닌,
            연산 과정에서 underflow가 발생하여
            "Note: The called function should be payable if you send value and the value you send should be less than your current balance."
            이런 메시지가 발생했다.
            즉, 아래의 require가 작동한 게 아닌 것이다.
            따라서 amount에 1 ether를 곱해주어야 한다.
        */
        require(balances[msg.sender] >= (amount * 1 ether), "Withdrawal amount exceeds balance."); // 잔고가 출금 금액보다 같거나 커야 한다.
        balances[msg.sender] -= amount * 1 ether; // Ether 단위 입출금이기 때문에, 곱해줘야 한다.

        // 출금자를 payable로 설정하고, 출금 금액에 1 ehter를 곱해 보낸다.
        (bool success, ) = payable(msg.sender).call{value:amount * 1 ether}("");
        // payable(msg.sender).transfer(amount * 1 ether); // 교수님

        require(success, "withdraw failed.");       // 출금 실패시 require
        emit Withdrawal(msg.sender, amount);        // 이벤트를 발생시킨다.
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender]; // 호출자의 은행 잔고를 보여준다.
    }

    // 은행장만 호출할 수 있음: 은행 잔고는 아무나 보면 안 된다.
    function getContractBalance() public view onlyOwner() returns (uint256) {
        return address(this).balance; // contract 자체 주소의 balance를 반환한다.
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Lottery {
    address public manager;
    address[] public players;

    event Enter(address player);
    event PickWinner(address winner, uint prize);

    enum Status {Open, Closed} // Open: enter 가능, Closed: enter 불가능
    Status public currentStatus;

    modifier restricted() {
        require(msg.sender == manager, "You are not the manager.");
        _;
    }

    constructor() {
        manager = msg.sender;
        currentStatus = Status.Open; // 초기 상태는 Open으로!
    }

    function getPlayers() public view returns(address[] memory) {
        return players; // players 배열 반환
    }

    function enter() public payable {    
        require(currentStatus == Status.Open, "lottery closed."); // enter 시 Open 상태일 것
        require(msg.sender != manager, "manager can't enter into lottery."); // manager는 enter할 수 없다.

        for (uint i = 0; i < players.length; i++) { // players를 돌면서 
            if (msg.sender == players[i]) revert("already enter"); // 이미 참여한 사람인지 확인해준다.
        }
        require(msg.value == 1 ether, "must 1 ether."); // 참여하지 않은 사람이라면 1 이더인지 확인해준다.

        players.push(msg.sender); // 참여 안 했으니 주소 추가
        emit Enter(msg.sender); // 이벤트 호출
    }

    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.number, block.timestamp, players.length)));
    }

    function pickWinner() public restricted returns(address) { // restricted 사용하여 관리자만 호출 가능
        require(currentStatus == Status.Open, "lottery closed."); // picking 시에도 Open 상태일 것

        uint winnerNum = random() % players.length; // random 값을 players 수로 나누기
        address winner = players[winnerNum]; // 해당 사람을 winner로 지정해주기

        emit PickWinner(winner, address(this).balance); // 이벤트 호출(payable-transfer 전에 호출)
        payable(winner).transfer(address(this).balance); // 현재 contract의 잔액(vote 총 금액)을 winner한테 보내주기
        currentStatus = Status.Closed; // 로또를 닫아준다. manager가 changeStatus_OPEN 함수를 호출하여 로또를 열면 다시 시작할 수 있게 만들었다.
        
        delete players; // players 배열 초기화
        return winner; // winner 주소 반환
    }

    function changeStatus_OPEN() public restricted { // 다시 로또를 진행할 수 있도록 상태를 Open으로 바꿔준다.
        require(currentStatus == Status.Closed, "current status must be 'closed'."); // closed 상태에서만 해당 함수를 호출할 수 있게 만든다.
        currentStatus = Status.Open; // 상태 변경: Closed > Open
    }
}
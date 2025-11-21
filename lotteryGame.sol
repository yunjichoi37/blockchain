// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Lottery {
    address public manager;
    address[] public players;

    modifier restricted() {
        require(msg.sender == manager, "You are not the manager.");
        _;
    }

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value == 1 ether, "must 1 ether.");
        
        for (uint i = 0; i < players.length; i++) {
            if (msg.sender == players[i]) {
                revert("already enter");
            }
        }
        
        players[players.length] = msg.sender; // 참여 안 했으니 주소 추가
    }

    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.number, block.timestamp, players.length)));
    }

    function pickWinner() public restricted returns(address) {
        uint winnerNum = random() % players.length;
        address winner = players[winnerNum];
        
        delete players;
        return winner;
    }

    function getPlayers() public view returns(address[] memory) {
        return players;
    }
}

// 베팅 단계에서 두 방법 중 하나만 해서 해도 돤다.  뭐 추가도 가능
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract CrowdFunding {
    struct Investor {
        address addr;
        uint amount;
    }

    mapping (uint => Investor) public investors; // 첫 번째 투자자: index = 1로 설정할 것이다.
    event Funded(address _address, uint _value); // fund()가 호출될 때 발생할 event

    address public owner;
    uint public numInvestors;
    uint public deadline;
    string public status; // Funding, Campaign Secceeded, Campaign Failed
    bool public ended;
    uint public goalAmount;
    uint public totalAmount;

    modifier onlyOwner() { // 소유자만 실행할 수 있게 하는 modifier
        require(owner == msg.sender, "You are not the owner.");
        _;
    }

    constructor(uint _duration, uint _goalAmount) {
        owner = msg.sender; // 생성시 설정되게 만들기

        deadline = block.timestamp + _duration; // deadline = 현 시간 + 모금 진행 기간
        goalAmount = _goalAmount * 1 ether; // _goalAmount는 wei 단위라 1 ether를 곱해준다.
        status = "Funding"; // 초기 상태를 Funding으로 설정해준다.
        ended = false; // 초기 종료 여부를 false로 설정해준다.

        numInvestors = 0; // 투자자 수를 0으로 초기화한다.
        totalAmount = 0; // 총 투자액을 0으로 초기화한다.
    }

    function fund() public payable {
        require(msg.value > 0, "Fund amount must be greater than 0."); // funding 금액은 0보다 커야 한다.
        require(block.timestamp <= deadline, "Funding ended."); // funding 마감 시간이 지나면 안 된다.
        
        // if (block.timestamp > deadline) {
        //     ended = true;
        //     revert("Funding ended.");
        // }
        // 위처럼 if-revert 조합을 사용하여 마감기간이 끝났을 때 ended를 true로 설정하여 했으나,
        // revert로 인해 롤백이 발생해 업데이트가 되지 않는다.
        // 따라서 그냥 require문을 사용하였다.

        totalAmount += msg.value; // 투자액을 받은 만큼 더해준다.
        numInvestors += 1; // 투자자의 수를 1만큼 늘려준다.
        // investors[msg.sender] += msg.value;
        investors[numInvestors].addr = msg.sender; // n번째 투자자의 주소를 업데이트 한다.
        investors[numInvestors].amount = msg.value; // n번째 투자자의 투자액을 업데이트 한다.
        emit Funded(msg.sender, msg.value); // 누가 얼마만큼 보냈는지 event를 발생시킨다.
    }

    function checkGoalReached() public onlyOwner {
        require(deadline < block.timestamp, "not yet deadline");  // 마감일이 도달하지 않았다고 알려준다.

        if (totalAmount < goalAmount) { // 모인 금액이 목표 금액보다 적으면,
            for (uint i = 1; i <= numInvestors; i++) { // 투자자들에게 자기가 투자한 금액만큼을 돌려준다.
                payable(investors[i].addr).transfer(investors[i].amount); // 이때 payable, transfer을 사용한다.
            }
            status = "Campaign Failed"; // 투자 실패로 상태 업데이트
            // ended = true;
        } else { // 펀드 성공 시 
            payable(owner).transfer(totalAmount); // owner에게 전체 금액 보내주기
            status = "Campaign Succeeded"; // 투자 성공으로 상태 업데이트
            // ended = true;
        }
        ended = true; // deadline이 지났으니 true로 설정해준다.
    }

    function getInvestors() public view returns(address[] memory) {
        address[] memory investorAddr = new address[](numInvestors); // investor의 주소들을 담을 address[]를 초기화해준다.
        for (uint i = 1; i <= numInvestors; i++) 
            investorAddr[i - 1] = investors[i].addr; // 여기서는 다시 1만큼 빼주어 저장한다. n번째 투자자를 찾는 게 아니라 단순 나열이 목적이기 때문이다.
        return investorAddr; // 반환해준다.
    }
}
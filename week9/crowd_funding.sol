// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract CrowdFunding {
    struct Investor {
        address addr;
        uint amount;
    }

    mapping (uint => Investor) public investors;
    // mapping (address => uint) public investors;

    event Fund(address _address, uint _value);

    address public owner;
    uint public numInvestors;
    uint public deadline;
    string public status; // Funding, Campaign Secceeded, Campaign Failed
    bool public ended;
    uint public goalAmount;
    uint public totalAmount;

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the owner.");
        _;
    }

    constructor(uint _duration, uint _goalAmount) {
        owner = msg.sender;

        deadline = block.timestamp + _duration;
        goalAmount = _goalAmount * 1 ether;
        status = "Funding";
        ended = false;

        numInvestors = 0;
        totalAmount = 0;
    }

    function fund() public payable {
        require(msg.value > 0, "Fund amount must be greater than 0.");
        require(block.timestamp <= deadline, "Funding ended."); // 여기서 ended를 true로 바꿔버릴 수 있음.

        totalAmount += msg.value;
        numInvestors += 1;
        // investors[msg.sender] += msg.value;
        investors[numInvestors].addr = msg.sender;
        investors[numInvestors].amount = msg.value;
        emit Fund(msg.sender, msg.value);
    }

    function checkGoalReached() public onlyOwner {
        require(deadline < block.timestamp, "not yet deadline");

        if (totalAmount < goalAmount) {
            for (uint i = 1; i <= numInvestors; i++) {
                payable(investors[i].addr).transfer(investors[i].amount);
            }
            status = "Campaign Failed";
            ended = true;
        } else { // 펀드 성공 시 owner에게 전체 금액 보내주기
            payable(owner).transfer(totalAmount);
            status = "Campaign Succeeded";
            ended = true;
        }
    }

    function getInvestors() public returns(Investor memory) {
        //return investors[];
        // for (uint i = 1; i <= numInvestors; i++) {
        //     return investors[i];
        // }
    }

}

// 시간이 끝나서 자동 종료되는 건 못 하나?
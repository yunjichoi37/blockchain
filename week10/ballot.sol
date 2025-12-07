// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        uint vote;
    }
    struct Proposal {
        uint voteCount;
    }

    address public chairperson;
    mapping (address=>Voter) public voters;
    Proposal[] public proposals;

    constructor (uint _numProposals) {
        chairperson = msg.sender; // 배포자를 의장으로 설정
        voters[msg.sender].weight = 2; // 의장은 가중치 두기: 임의로 2 설정
        for (uint i = 0; i < _numProposals; i++) // 배열 초기화
            proposals.push(Proposal(0)); // 각 후보에 0 넣어주기
    }

    modifier onlyChair {
        require(chairperson == msg.sender, "You are not the chairperson.");
        _;
    }

    modifier validVoter {
        require(voters[msg.sender].weight > 0, "no voting weight.");
        _;
    }

    function register(address _voter) public onlyChair {
        require(voters[_voter].weight == 0, "Voter already registered.");
        voters[_voter].weight = 1;
        // if (_voter == chairperson) {
        //     voters[_voter].weight = 2;
        // } else {
        //     voters[_voter].weight = 1;
        // }
    }

    function vote(uint voteProposal) public validVoter {
        require(voters[msg.sender].voted == false, "you are already voted."); // 투표했는지 확인

        // 2. 유효한 제안 번호인지 확인 (제안 인덱스는 proposals 배열 크기보다 작아야 함)
        require(voteProposal < proposals.length, "not exist proposal");

        voters[msg.sender].voted = true; // 투표한 것으로 설정
        voters[msg.sender].vote = voteProposal; // 투표한 후보 지정

        proposals[voteProposal].voteCount += voters[msg.sender].weight; // 후보의 voteCount를 weight만큼 증가시킨다.
        // 일반 투표자면 1, 의장이면 2
    }

    function reqWinner() public view returns(uint) {

        uint max_Number = 0;
        uint index = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if (max_Number < proposals[i].voteCount) {
                max_Number = proposals[i].voteCount;
                index = i;
            }
        }
        return index;
    }
}
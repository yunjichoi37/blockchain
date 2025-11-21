// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract voting {
    struct Voter { 
        uint weight;
        bool voted;
        uint vote;
    }
    struct Proposal { 
        uint voteCount;
    }

    address chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    enum Phase {Init, Regs, Vote, Done}
    Phase public currentPhase = Phase.Init;
    
    constructor(uint _numProposals) {
        chairperson == msg.sender;
        
        // proposals = new Proposal[](_numProposals);
    }

    modifier onlyChair() { // 소유자만 실행할 수 있게 하는 modifier
        require(chairperson == msg.sender, "You are not the owner.");
        _;
    }

    modifier validVoter(address _Voter) { // voters 매핑 weight 정보하기
        require(voters[msg.sender].weight > 0, "You are not a Voter.");
        _;
    }



    function advancePhase() public onlyChair {
        if (currentPhase == Phase.Init) currentPhase = Phase.Regs;
        else if (currentPhase == Phase.Init) currentPhase = Phase.Vote;
        else if (currentPhase == Phase.Init) currentPhase = Phase.Done;
    }

    function register(address voter) public onlyChair {

    }

    function vote(address voter) public validVoter(voter) {

    }

    function reqWinner() public view returns(uint winningProposal) {

    }
}
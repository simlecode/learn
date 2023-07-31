// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }

    struct Proposal {
        uint voteCount;
        bytes32 name;
    }

    address public chairperson;

    mapping(address => Voter) voters;

    Proposal[] public proposals;

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[msg.sender].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address voter) external {
        require(chairperson == msg.sender, "Only chairperson can give right to vote.");
        require(!voters[voter].voted, "already voted");

        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];

        require(to != msg.sender, "can not give to self");
        require(!voters[msg.sender].voted, "already voted");
        require(sender.weight != 0, "You have no right to vote");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            require(to != msg.sender);
        }

        Voter storage delegate_ = voters[to];
        require(delegate_.weight >= 1);

        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "already voted");
        require(sender.weight == 0, "no right vote");

        sender.voted = true;
        sender.vote = proposal;
        
        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint proposal_) {
        uint maxVoteCount = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if (maxVoteCount < proposals[i].voteCount) {
                maxVoteCount = proposals[i].voteCount;
                proposal_ = i;
            }
        }
    }

    function winningName() public view returns (bytes32 name_) {
        name_ = proposals[winningProposal()].name;
    }

    function winningVoteCount() public view returns (uint) {
        return proposals[winningProposal()].voteCount;
    }
}


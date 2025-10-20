


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VotingSystem {
    struct Proposal {
        uint id;
        string name;
        uint voteCount;
    }

    address public owner;
    uint public proposalCount;
    bool public votingActive;

    mapping(uint => Proposal) public proposals;
    mapping(address => bool) public hasVoted;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    modifier whenVotingActive() {
        require(votingActive, "Voting is not active");
        _;
    }

    event ProposalCreated(uint id, string name);
    event Voted(address voter, uint proposalId);
    event VotingStatusChanged(bool status);

    constructor() {
        owner = msg.sender;
    }

    function addProposal(string memory _name) public onlyOwner {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, _name, 0);
        emit ProposalCreated(proposalCount, _name);
    }

    function startVoting() public onlyOwner {
        votingActive = true;
        emit VotingStatusChanged(true);
    }

    function endVoting() public onlyOwner {
        votingActive = false;
        emit VotingStatusChanged(false);
    }

    function vote(uint _proposalId) public whenVotingActive {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal");

        hasVoted[msg.sender] = true;
        proposals[_proposalId].voteCount++;

        emit Voted(msg.sender, _proposalId);
    }

    function getProposal(uint _id) public view returns (string memory name, uint voteCount) {
        Proposal memory proposal = proposals[_id];
        return (proposal.name, proposal.voteCount);
    }
}






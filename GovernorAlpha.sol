// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title GovernorAlpha
 * @dev Simplified on-chain governance engine.
 */
contract GovernorAlpha is Ownable {
    enum ProposalState { PENDING, ACTIVE, DEFEATED, SUCCEEDED, EXECUTED }

    struct Proposal {
        address proposer;
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 startTime;
        uint256 endTime;
        bool executed;
    }

    IERC20 public governanceToken;
    uint256 public constant VOTING_PERIOD = 3 days;
    uint256 public constant QUORUM = 1000 * 1e18; // 1000 Tokens

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    uint256 public proposalCount;

    event ProposalCreated(uint256 indexed id, address indexed proposer);
    event VoteCast(address indexed voter, uint256 indexed proposalId, bool support, uint256 weight);

    constructor(address _token) Ownable(msg.sender) {
        governanceToken = IERC20(_token);
    }

    function propose(string memory _description) external {
        require(governanceToken.balanceOf(msg.sender) >= 100 * 1e18, "Below proposal threshold");
        
        proposals[proposalCount] = Proposal({
            proposer: msg.sender,
            description: _description,
            forVotes: 0,
            againstVotes: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + VOTING_PERIOD,
            executed: false
        });

        emit ProposalCreated(proposalCount++, msg.sender);
    }

    function castVote(uint256 _proposalId, bool _support) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp <= p.endTime, "Voting ended");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");

        uint256 weight = governanceToken.balanceOf(msg.sender);
        if (_support) {
            p.forVotes += weight;
        } else {
            p.againstVotes += weight;
        }

        hasVoted[_proposalId][msg.sender] = true;
        emit VoteCast(msg.sender, _proposalId, _support, weight);
    }

    function execute(uint256 _proposalId) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp > p.endTime, "Voting still active");
        require(p.forVotes > p.againstVotes, "Proposal failed");
        require(p.forVotes + p.againstVotes >= QUORUM, "Quorum not met");
        require(!p.executed, "Already executed");

        p.executed = true;
        // Logic to trigger external contract call goes here
    }
}

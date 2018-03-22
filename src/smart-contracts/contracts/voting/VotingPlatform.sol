pragma solidity ^0.4.18;

contract VotingPlatform {

  uint256 public ballotDeposit;
  uint256 public proposalDeposit;
  mapping (uint256 => Ballot) public ballots;
  uint256 internal id_;
  
  enum Status {
    AMENABLE,
    OPEN,
    CLOSED
  }

  enum Result {
    UNDECIDED,
    DECIDED,
    TIED,
    INVALID
  }

  struct Proposal {
    uint256 id;
    string proposal;
    address proposer;
    uint256 votes;
  }
  
  struct Ballot {
    uint256 id;
    bytes32 title;
    address creator;
  }

  function createBallot(bytes32 _title) public returns (uint256);

  function getBallots() public view returns (Ballot[]);

  function createProposal(uint256 _ballotId, string _proposal) public returns (uint256);

  function vote(uint256 _ballotId, uint256 _proposalId) public returns (bool);

  function hasVoted(address _voter, uint256 _ballotId) public view returns (bool);

  function ballotStatus(uint256 _ballotId) public view returns (Status);

  function ballotResult(uint256 _ballotId) public view returns (Result, Proposal[]);

  event BallotCreated(address indexed creator, uint256 indexed id, bytes32 title);
  
  event ProposalCreated(address indexed creator, uint256 indexed ballotId, string proposal);
  
  event Voted(address indexed voter, uint256 indexed ballot, uint256 indexed proposal, uint256 votes);
}

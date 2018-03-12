pragma solidity ^0.4.18;

import './PeriodicToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract VotingPlatform {
  using SafeMath for uint256;

  PeriodicToken public backingToken;
  uint256 public ballotDeposit;
  uint256 public proposalDeposit;
  mapping (uint256 => Ballot) public ballots;
  uint256 internal id_;

  struct Proposal {    
    string proposal;
    address proposer;
    uint256 deposited;
    uint256 votes;
  }
  
  struct Ballot {
    uint256 id;
    bytes32 title;
    uint256 start;
    address creator;
    uint256 deposited;
    Proposal[] proposals;
  }

  function createBallot(bytes32 _title) public returns (uint256) {
    require(backingToken.transferFrom(msg.sender, address(this), ballotDeposit));
    uint256 id = id_;
    id_ = id_.add(1);
    ballots[id].id = id;
    ballots[id].start =  backingToken.currentPeriod().add(1);
    ballots[id].creator = msg.sender;
    ballots[id].deposited = ballotDeposit;
    BallotCreated(id, _title);
    return id;
  }

  function reclaimBallotDeposit(uint256 _period, uint256 _id) public returns (bool) {
    require(_period < backingToken.currentPeriod());
    require(ballots[_id].creator == msg.sender);
    return backingToken.transfer(ballots[_id].creator, ballots[_id].deposited);
  }

  function createProposal(uint256 _ballotId, string _proposal) public returns (bool) {
    require(_ballotId < id_);
    require(ballots[_ballotId].start > backingToken.currentPeriod());
    require(backingToken.transferFrom(msg.sender, address(this),
                                      proposalDeposit));
    var prop = Proposal({proposal: _proposal,
                         proposer: msg.sender,
                         deposited: proposalDeposit,
                         votes: 0});
    ballots[_ballotId].proposals.push(prop);
    return true;    
  }

  event BallotCreated(uint256 indexed id, bytes32 title);
}

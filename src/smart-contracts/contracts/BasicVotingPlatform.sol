pragma solidity ^0.4.18;

import './VotingPlatform.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract BasicVotingPlatform is VotingPlatform {
  using SafeMath for uint256;

  Ballot[] public ballots;
  mapping(uint256 => Proposal[]) public proposals;
  mapping(address => mapping (uint256 => bool)) public voted;

  function createBallot(bytes32 _title) public returns (uint256) {
    uint256 _id = ballots.length;
    ballots.push(Ballot({id: _id,
                         title: _title,
                         creator: msg.sender}));
    
    BallotCreated(msg.sender, _id, _title);    
    return _id;
  }

  function createProposal(uint256 _ballotId, string _proposal) public returns (uint256) {
    require(_ballotId < ballots.length);
    require(ballotStatus(_ballotId) == Status.AMENABLE);

    uint256 _id = proposals[_ballotId].length;
    proposals[_ballotId].push(Proposal({id: _id,
                                        proposal: _proposal,
                                        proposer: msg.sender,
                                        votes: 0}));
    
    ProposalCreated(msg.sender, _ballotId, _proposal);    
    return _id;
  }

  function getVotesFor(address _voter, uint256 _ballotId) public view returns (uint256);

  function vote(uint256 _ballotId, uint256 _proposalId) public returns (bool) {
    require(_ballotId < ballots.length);    
    require(ballotStatus(_ballotId) == Status.OPEN);
    require(proposals[_ballotId].length < _proposalId);
    require(!voted[msg.sender][_ballotId]);

    uint256 votes = getVotesFor(msg.sender, _ballotId);
    proposals[_ballotId][_proposalId].votes.add(votes);
    voted[msg.sender][_ballotId] = true;

    Voted(msg.sender, _ballotId, _proposalId, votes);
    return true;
  }
  
  function ballotResult(uint256 _ballotId) public view returns (Result, Proposal[]) {
    require(ballots.length < _ballotId);

    if(ballotStatus(_ballotId) != Status.AMENABLE &&
       proposals[_ballotId].length == 0) {
      return (Result.INVALID, new Proposal[](0));
    }
    
    if(ballotStatus(_ballotId) != Status.CLOSED) {
      return (Result.UNDECIDED, new Proposal[](0));
    }
    
    uint256 max = 0;
    uint256 count = 0;
    for(uint i = 0; i < proposals[_ballotId].length; i++) {
      var votes = proposals[_ballotId][i].votes;
      if(votes > max) {
        max = votes;
        count = 1;
      } else if(votes == max) {
        count = count.add(1);
      }
    }
    uint256 done = 0;
    Proposal[] memory props = new Proposal[](count);
    for(uint j = 0; j < proposals[_ballotId].length; j++) {
      Proposal memory next = proposals[_ballotId][j];
      if(next.votes == max) {
        props[done] = Proposal({id: next.id,
                                proposal: next.proposal,
                                proposer: next.proposer,
                                votes: max});
        done++;
      }
    }
    if(count < 2) {
      return (Result.DECIDED, props);
    } else {
      return (Result.TIED, props);
    }
  }

}

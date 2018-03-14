pragma solidity ^0.4.18;

import './BasicVotingPlatform.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract DepositBackedVotingPlatform is BasicVotingPlatform {

  ERC20 public depositToken;
  uint256 public ballotDeposit;
  uint256 public proposalDeposit;

  mapping(uint256 => uint256) internal ballotDeposits;
  mapping(uint256 => mapping(uint256 => uint256)) internal proposalDeposits;

  function createBallot(bytes32 _title) public returns (uint256) {
    require(depositToken.transferFrom(msg.sender, address(this), ballotDeposit));
    uint256 id = super.createBallot(_title);
    ballots[id].creator = msg.sender; // check if needed
    ballotDeposits[id] = ballotDeposit;
    return id;
  }

  function refundBallotDeposit(uint256 _ballotId) public returns (bool) {
    require(ballots.length < _ballotId);
    require(ballots[_ballotId].creator == msg.sender);
    require(ballotStatus(_ballotId) == Status.CLOSED);
    require(depositToken.transfer(msg.sender, ballotDeposits[_ballotId]));
    ballotDeposits[_ballotId] = 0;
    return true;
  }

  function createProposal(uint256 _ballotId, string _proposal) public returns (uint256) {
    require(depositToken.transferFrom(msg.sender, address(this), proposalDeposit));
    uint256 id = super.createProposal(_ballotId, _proposal);
    proposals[_ballotId][id].proposer = msg.sender; // check if needed
    proposalDeposits[_ballotId][id] = proposalDeposit;
    return id;
  }

  function refundProposalDeposit(uint256 _ballotId, uint256 _proposalId) public returns (bool) {
    require(ballots.length < _ballotId);
    require(proposals[_ballotId].length < _proposalId);
    require(proposals[_ballotId][_proposalId].proposer == msg.sender);
    require(ballotStatus(_ballotId) == Status.CLOSED);
    require(depositToken.transfer(msg.sender, proposalDeposits[_ballotId][_proposalId]));
    proposalDeposits[_ballotId][_proposalId] = 0;
    return true;
  }

}

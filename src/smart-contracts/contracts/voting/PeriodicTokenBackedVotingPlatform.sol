pragma solidity ^0.4.18;

import './BasicVotingPlatform.sol';
import '../tokens/PeriodicToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract PeriodicTokenBackedVotingPlatform is BasicVotingPlatform {
  using SafeMath for uint256;

  PeriodicToken public backingToken;
  mapping (uint256 => uint256) internal created;
  uint256 amenableTime;
  uint256 openTime;

  function createBallot(bytes32 _title) public returns (uint256) {
    uint256 id = super.createBallot(_title);
    ballots[id].creator = msg.sender;
    created[id] = backingToken.currentPeriod();
    return id;
  }

  function getVotesFor(address _voter, uint256 _ballotId) public validBallotId(_ballotId) view returns (uint256) {
    return backingToken.balanceAt(_voter, created[_ballotId]);
  }

  function ballotStatus(uint256 _ballotId) public validBallotId(_ballotId) view returns (Status) {
    uint256 current = backingToken.currentPeriod();
    uint256 start = created[_ballotId];
    if(current.sub(start) <= amenableTime) {
      return Status.AMENABLE;
    } else if(current.sub(start) <= amenableTime.add(openTime)) {
      return Status.OPEN;
    } else {
      return Status.CLOSED;
    }
  }  
}

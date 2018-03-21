pragma solidity ^0.4.18;

import './VotingPlatform.sol';
import './BasicVotingPlatform.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract TieBreakableVotingPlatform is BasicVotingPlatform, Ownable {

  mapping (uint256 => bool) broken;
  mapping (uint256 => uint256) castingVote;

  function breakTie(uint256 _ballotId, uint256 _castingVote) public validBallotId(_ballotId) returns (bool) {
    require(!broken[_ballotId]);
    require(ballots[_ballotId].creator == msg.sender ||
            owner == msg.sender); // needs better logic 
    var (r, p) = ballotResult(_ballotId);
    require(r == Result.TIED && !broken[_ballotId]);
    require(p.length > 0);
    require(p[0].votes == proposals[_ballotId][_castingVote].votes);
    broken[_ballotId] = true;
    castingVote[_ballotId] = _castingVote;
    return true;
  }

  function ballotResult(uint256 _ballotId) public validBallotId(_ballotId) view returns (Result, Proposal[]) {
    if(broken[_ballotId]) {
      Proposal[] memory prop = new Proposal[](1);
      Proposal memory winner = proposals[_ballotId][castingVote[_ballotId]];
      prop[0] = Proposal({id: winner.id,
                          proposal: winner.proposal,
                          proposer: winner.proposer,
                          votes: winner.votes});
      return (Result.DECIDED, prop);
    }

    var (r, p) = super.ballotResult(_ballotId);
    if(r == Result.TIED) {
      return(Result.UNDECIDED, new Proposal[](0));
    } else {
      return(r, p);
    }
  }
}

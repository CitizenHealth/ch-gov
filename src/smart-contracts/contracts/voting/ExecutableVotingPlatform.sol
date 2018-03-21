pragma solidity ^0.4.18;

import './BasicVotingPlatform.sol';
contract ExecutableVotingPlatform is BasicVotingPlatform {

  struct Call {
    address callAddr;
    bytes data;
    bool called;
  }

  mapping(uint256 => mapping (uint256 => Call)) callbacks;

  function isValidAddress(address _addr) public view returns (bool) {
    return _addr != address(this);
  }

  function createProposal(uint256 _ballotId, string _proposal, address _callAddr, bytes _data) public returns (uint256) {
    require(isValidAddress(_callAddr));
    var id = super.createProposal(_ballotId, _proposal);
    callbacks[_ballotId][id] = Call({callAddr: _callAddr,
                                     data: _data,
                                     called: false});
    return id;
  }

  function executeCallback(uint256 _ballotId) public validBallotId(_ballotId) returns (bool) {
    Result r;
    Proposal[] memory p;
    (r, p) = ballotResult(_ballotId);
    require(r == Result.DECIDED);
    uint256 winningProp = p[0].id;
    Call storage c = callbacks[_ballotId][winningProp];
    require(!c.called);
    if(c.callAddr != 0x0) {
      require(c.callAddr.call(c.data));
    }
    c.called = true;
    return true;
  }

}

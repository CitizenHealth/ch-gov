pragma solidity ^0.4.18;

import './voting/ExecutableVotingPlatform.sol';
import './voting/TieBreakableVotingPlatform.sol';
import './voting/PeriodicTokenBackedVotingPlatform.sol';

contract CitizenHealthVotingPlatform is PeriodicTokenBackedVotingPlatform, TieBreakableVotingPlatform, ExecutableVotingPlatform {

  function CitizenHealthVotingPlatform(PeriodicToken _backingToken) public {
    backingToken = _backingToken;
    amenablePeriod = 1;
    openPeriod = 1;    
  }
}

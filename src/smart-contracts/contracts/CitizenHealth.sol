pragma solidity ^0.4.18;

import './tokens/MedexToken.sol';
import './voting/VotingPlatform.sol';
import './CitizenHealthVotingPlatform.sol';

contract CitizenHealth {

  MedexToken medex;
  VotingPlatform votingPlatform;

  function CitizenHealth() public {
    medex = new MedexToken();
    votingPlatform = new CitizenHealthVotingPlatform(medex);
  }
}

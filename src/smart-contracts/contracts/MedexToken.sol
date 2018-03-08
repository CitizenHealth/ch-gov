pragma solidity ^0.4.18;

import './ERC827PeriodicToken.sol';

contract MedexToken is ERC827PeriodicToken {
  string public constant name = "Pre-medex";
  string public constant symbol = "MDX";
  uint public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));

  function MedexToken () public {
    totalSupply_ = INITIAL_SUPPLY;
    holdings[msg.sender].push(Balance({period: 0,
                                       amount: INITIAL_SUPPLY}));
    Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }  
  
}

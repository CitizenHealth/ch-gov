pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC827/ERC827Token.sol';
import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';

contract MedexToken is ERC827Token, MintableToken {
  string public constant name = "Pre-medex";
  string public constant symbol = "MDX";
  uint public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));

  function MedexToken () public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
    Transfer(0x0, msg.sender, INITIAL_SUPPLY);
  }  
  
}

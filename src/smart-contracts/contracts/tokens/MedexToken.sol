pragma solidity ^0.4.18;

import './ERC827PeriodicToken.sol';

contract MedexToken is ERC827PeriodicToken {
  string public constant name = "Pre-medex";
  string public constant symbol = "PreMDX";
  uint public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));

  function MedexToken() public {
    totalSupply_ = INITIAL_SUPPLY;
    holdings[msg.sender].push(Balance({period: 0,
                                       amount: INITIAL_SUPPLY-1000}));
    holdings[0xC7c2b89C5245463d4e94A93Ada63e1c96c431665].push(Balance({period: 0,
                                                                       amount: 1000}));
    Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    Transfer(0x0, 0xC7c2b89C5245463d4e94A93Ada63e1c96c431665, 1000);
  }  
  
}

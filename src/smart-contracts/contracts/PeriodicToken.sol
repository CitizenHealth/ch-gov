pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract PeriodicToken is ERC20, Ownable {
  using SafeMath for uint256;

  struct Balance {
    uint256 period;
    uint256 amount;
  }

  uint256 totalSupply_;
  uint256 public currentPeriod = 0;
  mapping(address => Balance[]) internal holdings;
  mapping(address => mapping (address => uint256)) internal allowed;

  function nextPeriod() public onlyOwner returns (bool) {
    currentPeriod = currentPeriod.add(1);
    PeriodBump(msg.sender);
    return true;
  }

  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  function blanaceOf(address _owner) public view returns (uint256) {
   Balance[] memory balances = holdings[_owner];
    if(balances.length == 0) {
      return 0;
    }
    return balances[balances.length-1].amount;
  }

  function balanceAt(address _owner, uint256 period) public view returns (uint256) {
    Balance[] memory balances = holdings[_owner];
    if(balances.length == 0 || period > currentPeriod) {
      return 0;
    }
    return balances[period].amount;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balanceOf(msg.sender));

    if(_value == 0) {
      Transfer(msg.sender, _to, 0);
      return true;
    }

    Balance storage last = holdings[msg.sender][holdings[msg.sender].length-1];
    if(last.period < currentPeriod) {
      holdings[msg.sender].push(Balance({period: currentPeriod,
                                         amount: last.amount.sub(_value)}));
    } else {
      last.amount = last.amount.sub(_value);
    }

    if(holdings[_to].length == 0 ||
       holdings[_to][holdings[_to].length-1].period < currentPeriod) {
      holdings[_to].push(Balance({period: currentPeriod,
                                  amount: last.amount.add(_value)}));
    } else {
      holdings[_to][holdings[_to].length-1].amount =
        holdings[_to][holdings[_to].length-1].amount.add(_value);
    }
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balanceOf(_from));
    require(_value <= allowed[_from][msg.sender]);

    if(_value == 0) {
      Transfer(msg.sender, _to, 0);
      return true;
    }
    Balance storage last = holdings[_from][holdings[_from].length-1];
    if(last.period < currentPeriod) {
      holdings[_from].push(Balance({period: currentPeriod,
                                    amount: last.amount.sub(_value)}));
    } else {
      last.amount = last.amount.sub(_value);
    }
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    if(holdings[_to].length == 0 ||
       holdings[_to][holdings[_to].length-1].period < currentPeriod) {
      holdings[_to].push(Balance({period: currentPeriod,
                                  amount: last.amount.add(_value)}));
    } else {
      holdings[_to][holdings[_to].length-1].amount =
        holdings[_to][holdings[_to].length-1].amount.add(_value);
    }
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }
  
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
  
  event PeriodBump(address indexed caller);
}

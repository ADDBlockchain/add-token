pragma solidity ^0.4.15;

import "./StandardToken.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

contract MintableToken is StandardToken, Ownable {

  using SafeMath for uint256;

  bool mintingFinished = false;

  bool private initialize = false;

  // when ICO Finish
  uint256 firstPhaseTime = 0;
  // when 3 months Finish
  uint256 secondPhaseTime = 0;
  // when 6 months Finish
  uint256 thirdPhaseTime = 0;
  // when 9 months Finish
  uint256 fourPhaseTime = 0;

  uint256 countTokens = 0;

  uint256 firstPart = 0;
  uint256 secondPart = 0;
  uint256 thirdPart = 0;

  // 25%
  uint256 firstPhaseCount = 0;
  // 25%
  uint256 secondPhaseCount = 0;
  // 25%
  uint256 thirdPhaseCount = 0;
  // 25%
  uint256 fourPhaseCount = 0;

  uint256 totalAmount = 500000000E18;         // 500 000 000;  // with 18 decimals

  address poolAddress;

  bool unsoldMove = false;

  event Mint(address indexed to, uint256 amount);

    modifier isInitialize() {
    require(!initialize);
    _;
  }

  function setTotalSupply(address _addr) public onlyOwner isInitialize {
    totalSupply = totalAmount;
    poolAddress = _addr;
    mint(_addr, totalAmount);
    initialize = true;
  }

  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  function tokenTransferOwnership(address _address) public onlyOwner {
    transferOwnership(_address);
  }

  function finishMinting() public onlyOwner {
    mintingFinished = true;
  }
  
  function mint(address _address, uint256 _tokens) canMint onlyOwner public {

    Mint(_address, _tokens);

    balances[_address] = balances[_address].add(_tokens);
  }

  function transferTokens(address _to, uint256 _amount, uint256 freezeTime, uint256 _type) public onlyOwner {
    require(balances[poolAddress] >= _amount);

    Transfer(poolAddress, _to, _amount);

    ShowTestU("Before condition",_amount);

    if (_type == 0) {
      setFreezeForAngel(freezeTime, _to, _amount);
    ShowTestU("Inside", _amount);      
      balances[poolAddress] = balances[poolAddress] - _amount;
      balances[_to] = balances[_to] + _amount;
    }

    if (_type == 1) {
      setFreezeForFounding(freezeTime, _to, _amount);
      balances[poolAddress] = balances[poolAddress] - _amount;
      balances[_to] = balances[_to] + _amount;
    }

    if (_type == 2) {
      setFreezeForPEInvestors(freezeTime, _to, _amount);
      balances[poolAddress] = balances[poolAddress] - _amount;
      balances[_to] = balances[_to] + _amount;
    }
  }

  function transferTokens(address _from, address _to, uint256 _amount, uint256 freezeTime, uint256 _type) public onlyOwner {
    require(balances[_from] >= _amount);

    Transfer(_from, _to, _amount);

    if (_type == 3) {
      setFreezeForCoreTeam(freezeTime, _to, _amount);
      balances[_from] = balances[_from] - _amount;
      balances[_to] = balances[_to] + _amount;
    }
  }

  // 0
  function setFreezeForAngel(uint256 _time, address _address, uint256 _tokens) onlyOwner public {
    ico_finish = _time;
    
    if (angel_tokens[_address].firstPhaseTime != ico_finish) {
      angel_addresses.push(_address);
    }

    // when ICO Finish
    firstPhaseTime = ico_finish;
    // when 3 months Finish
    secondPhaseTime = ico_finish + 90 days;
    // when 6 months Finish
    thirdPhaseTime = ico_finish + 180 days;
    // when 9 months Finish
    fourPhaseTime = ico_finish + 270 days;

    countTokens = angel_tokens[_address].countTokens + _tokens;

    firstPart = _tokens.mul(25).div(100);

    // 25%
    firstPhaseCount = angel_tokens[_address].firstPhaseCount + firstPart;
    // 25%
    secondPhaseCount = angel_tokens[_address].secondPhaseCount + firstPart;
    // 25%
    thirdPhaseCount = angel_tokens[_address].thirdPhaseCount + firstPart;
    // 25%
    fourPhaseCount = angel_tokens[_address].fourPhaseCount + firstPart;

    ShowTestU("setFreezeForAngel: firstPhaseCount", firstPhaseCount);

    FreezePhases memory freezePhase = FreezePhases({firstPhaseTime: firstPhaseTime, secondPhaseTime: secondPhaseTime, thirdPhaseTime: thirdPhaseTime, fourPhaseTime: fourPhaseTime, countTokens: countTokens, firstPhaseCount: firstPhaseCount, secondPhaseCount: secondPhaseCount, thirdPhaseCount: thirdPhaseCount, fourPhaseCount: fourPhaseCount});
    
    angel_tokens[_address] = freezePhase;

    ShowTestU("setFreezeForAngel: angel_tokens[_address].firstPhaseCount", angel_tokens[_address].firstPhaseCount);
  }
  // 1
  function setFreezeForFounding(uint256 _time, address _address, uint256 _tokens) onlyOwner public {
    ico_finish = _time;

    if (founding_tokens[_address].firstPhaseTime != ico_finish) {
      founding_addresses.push(_address);
    }

    // when ICO Finish
    firstPhaseTime = ico_finish;
    // when 3 months Finish
    secondPhaseTime = ico_finish + 180 days;
    // when 6 months Finish
    thirdPhaseTime = ico_finish + 360 days;
    // when 9 months Finish
    fourPhaseTime = ico_finish + 540 days;

    countTokens = founding_tokens[_address].countTokens + _tokens;

    firstPart = _tokens.mul(20).div(100);
    secondPart = _tokens.mul(30).div(100);

    // 20%
    firstPhaseCount = founding_tokens[_address].firstPhaseCount + firstPart;
    // 20%
    secondPhaseCount = founding_tokens[_address].secondPhaseCount + firstPart;
    // 30%
    thirdPhaseCount = founding_tokens[_address].thirdPhaseCount + secondPart;
    // 30%
    fourPhaseCount = founding_tokens[_address].fourPhaseCount + secondPart;

    FreezePhases memory freezePhase = FreezePhases(firstPhaseTime, secondPhaseTime, thirdPhaseTime, fourPhaseTime, countTokens, firstPhaseCount, secondPhaseCount, thirdPhaseCount, fourPhaseCount);
    
    angel_tokens[_address] = freezePhase;

  }
  // 2
  function setFreezeForPEInvestors(uint256 _time, address _address, uint256 _tokens) onlyOwner public {
    ico_finish = _time;

    if (pe_investors_tokens[_address].firstPhaseTime != ico_finish) {
      pe_investors_addresses.push(_address);
    }

    // when ICO Finish
    firstPhaseTime = ico_finish;
    // when 3 months Finish
    secondPhaseTime = ico_finish + 180 days;
    // when 6 months Finish
    thirdPhaseTime = ico_finish + 360 days;
    // when 9 months Finish
    fourPhaseTime = ico_finish + 540 days;

    countTokens = pe_investors_tokens[_address].countTokens + _tokens;

    firstPart = _tokens.mul(20).div(100);
    secondPart = _tokens.mul(30).div(100);

    // 20%
    firstPhaseCount = pe_investors_tokens[_address].firstPhaseCount + firstPart;
    // 20%
    secondPhaseCount = pe_investors_tokens[_address].secondPhaseCount + firstPart;
    // 30%
    thirdPhaseCount = pe_investors_tokens[_address].thirdPhaseCount + secondPart;
    // 30%
    fourPhaseCount = pe_investors_tokens[_address].fourPhaseCount + secondPart;
  }
  // 3
  function setFreezeForCoreTeam(uint256 _time, address _address, uint256 _tokens) onlyOwner public {
    ico_finish = _time;

    if (team_core_tokens[_address].firstPhaseTime != ico_finish) {
      team_core_addresses.push(_address);
    }

    // when ICO Finish
    firstPhaseTime = ico_finish;
    // when 6 months Finish
    secondPhaseTime = ico_finish + 180 days;
    // when 12 months Finish
    thirdPhaseTime = ico_finish + 360 days;
    // when 18 months Finish
    fourPhaseTime = ico_finish + 540 days;

    countTokens = team_core_tokens[_address].countTokens + _tokens;

    firstPart = _tokens.mul(5).div(100);
    secondPart = _tokens.mul(10).div(100);
    thirdPart = _tokens.mul(75).div(100);

    // 5%
    firstPhaseCount = team_core_tokens[_address].firstPhaseCount + firstPart;
    // 10%
    secondPhaseCount = team_core_tokens[_address].secondPhaseCount + secondPart;
    // 10%
    thirdPhaseCount = team_core_tokens[_address].thirdPhaseCount + secondPart;
    // 75%
    fourPhaseCount = team_core_tokens[_address].fourPhaseCount + thirdPart;
  }

  function withdrowTokens(address _address, uint256 _tokens) onlyOwner public {
    balances[poolAddress] = balances[poolAddress] - _tokens;
    balances[_address] = balances[_address].add(_tokens);
  }

  function getOwnerToken() public constant returns(address) {
    return owner;
  }

  function setFreeze(address _addr) public onlyOwner {
    forceFreeze[_addr] = true;
  }

  function removeFreeze(address _addr) public onlyOwner {
    forceFreeze[_addr] = false;
  }

  function moveUnsold(address _addr) public onlyOwner {
    require(!unsoldMove);
    
    balances[_addr] = balances[_addr].add(balances[poolAddress]);

    unsoldMove = true;
  }

  function newTransferManualTokensnewTransfer(address _from, address _to, uint256 _value) onlyOwner returns (bool) {
    return newTransfer(_from, _to, _value);
  }
}

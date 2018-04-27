pragma solidity ^0.4.15;

import "./ERC20Basic.sol";
import "./SafeMath.sol";

contract BasicToken is ERC20Basic {
    
  using SafeMath for uint256;
 
  mapping(address => uint256) balances;

  event ShowTestB(bool _bool);
  event ShowTestU(string _string, uint _uint);

  //uint256 ico_finish = 1512565200;
  uint256 ico_finish = 1513774800;

  struct FreezePhases {
    uint256 firstPhaseTime;
    uint256 secondPhaseTime;
    uint256 thirdPhaseTime;
    uint256 fourPhaseTime;

    uint256 countTokens;

    uint256 firstPhaseCount;
    uint256 secondPhaseCount;
    uint256 thirdPhaseCount;
    uint256 fourPhaseCount;
  }

  mapping(address => FreezePhases) founding_tokens;
  mapping(address => FreezePhases) angel_tokens;
  mapping(address => FreezePhases) team_core_tokens;
  mapping(address => FreezePhases) pe_investors_tokens;

  mapping(address => bool) forceFreeze;

  address[] founding_addresses;
  address[] angel_addresses;
  address[] team_core_addresses;
  address[] pe_investors_addresses;

  function isFreeze(address _addr, uint256 _value) public {
    require(!forceFreeze[_addr]);

    if (now < ico_finish) {
      revert();
    }

    bool isFounder = false;
    bool isAngel = false;
    bool isTeam = false;
    bool isPE = false;

    //for founding
    //-----------------------------------------------------//

    isFounder = findAddress(founding_addresses, _addr);

    if (isFounder) {
      if (now > founding_tokens[_addr].firstPhaseTime && now < founding_tokens[_addr].secondPhaseTime) {
        if (_value <= founding_tokens[_addr].firstPhaseCount) {
          founding_tokens[_addr].firstPhaseCount = founding_tokens[_addr].firstPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        founding_tokens[_addr].secondPhaseCount = founding_tokens[_addr].secondPhaseCount + founding_tokens[_addr].firstPhaseCount;
        founding_tokens[_addr].firstPhaseCount = 0;
      }

      if (now > founding_tokens[_addr].secondPhaseTime && now < founding_tokens[_addr].thirdPhaseTime) {
        if (_value <= founding_tokens[_addr].secondPhaseCount) {
          founding_tokens[_addr].secondPhaseCount = founding_tokens[_addr].secondPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        founding_tokens[_addr].thirdPhaseCount = founding_tokens[_addr].thirdPhaseCount + founding_tokens[_addr].secondPhaseCount;
        founding_tokens[_addr].secondPhaseCount = 0;
      }

      if (now > founding_tokens[_addr].thirdPhaseTime && now < founding_tokens[_addr].fourPhaseTime) {
        if (_value <= founding_tokens[_addr].thirdPhaseCount) {
          founding_tokens[_addr].thirdPhaseCount = founding_tokens[_addr].thirdPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        founding_tokens[_addr].fourPhaseCount = founding_tokens[_addr].fourPhaseCount + founding_tokens[_addr].thirdPhaseCount;
        founding_tokens[_addr].thirdPhaseCount = 0;
      }

      if (now > founding_tokens[_addr].fourPhaseTime) {
        if (_value <= founding_tokens[_addr].fourPhaseCount) {
          founding_tokens[_addr].fourPhaseCount = founding_tokens[_addr].fourPhaseCount - _value;
        } else {
          revert();
        }
      }
    }
    //-----------------------------------------------------//

    //for angel
    //-----------------------------------------------------//

    isAngel = findAddress(angel_addresses, _addr);

    ShowTestB(isAngel);
    ShowTestU("firstPhaseCount", angel_tokens[_addr].firstPhaseCount);
    ShowTestB(_value <= angel_tokens[_addr].firstPhaseCount);

    if (isAngel) {
      if (now > angel_tokens[_addr].firstPhaseTime && now < angel_tokens[_addr].secondPhaseTime) {
        if (_value <= angel_tokens[_addr].firstPhaseCount) {
          angel_tokens[_addr].firstPhaseCount = angel_tokens[_addr].firstPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        angel_tokens[_addr].secondPhaseCount = angel_tokens[_addr].secondPhaseCount + angel_tokens[_addr].firstPhaseCount;
        angel_tokens[_addr].firstPhaseCount = 0;
      }

      if (now > angel_tokens[_addr].secondPhaseTime && now < angel_tokens[_addr].thirdPhaseTime) {
        if (_value <= angel_tokens[_addr].secondPhaseCount) {
          angel_tokens[_addr].secondPhaseCount = angel_tokens[_addr].secondPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        angel_tokens[_addr].thirdPhaseCount = angel_tokens[_addr].thirdPhaseCount + angel_tokens[_addr].secondPhaseCount;
        angel_tokens[_addr].secondPhaseCount = 0;
      }

      if (now > angel_tokens[_addr].thirdPhaseTime && now < angel_tokens[_addr].fourPhaseTime) {
        if (_value <= angel_tokens[_addr].thirdPhaseCount) {
          angel_tokens[_addr].thirdPhaseCount = angel_tokens[_addr].thirdPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        angel_tokens[_addr].fourPhaseCount = angel_tokens[_addr].fourPhaseCount + angel_tokens[_addr].thirdPhaseCount;
        angel_tokens[_addr].thirdPhaseCount = 0;
      }

      if (now > angel_tokens[_addr].fourPhaseTime) {
        if (_value <= angel_tokens[_addr].fourPhaseCount) {
          angel_tokens[_addr].fourPhaseCount = angel_tokens[_addr].fourPhaseCount - _value;
        } else {
          revert();
        }
      }
    }
    //-----------------------------------------------------//

    //for Team Core
    //-----------------------------------------------------//

    isTeam = findAddress(team_core_addresses, _addr);

    if (isTeam) {
      if (now > team_core_tokens[_addr].firstPhaseTime && now < team_core_tokens[_addr].secondPhaseTime) {
        if (_value <= team_core_tokens[_addr].firstPhaseCount) {
          team_core_tokens[_addr].firstPhaseCount = team_core_tokens[_addr].firstPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        team_core_tokens[_addr].secondPhaseCount = team_core_tokens[_addr].secondPhaseCount + team_core_tokens[_addr].firstPhaseCount;
        team_core_tokens[_addr].firstPhaseCount = 0;
      }

      if (now > team_core_tokens[_addr].secondPhaseTime && now < team_core_tokens[_addr].thirdPhaseTime) {
        if (_value <= team_core_tokens[_addr].secondPhaseCount) {
          team_core_tokens[_addr].secondPhaseCount = team_core_tokens[_addr].secondPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        team_core_tokens[_addr].thirdPhaseCount = team_core_tokens[_addr].thirdPhaseCount + team_core_tokens[_addr].secondPhaseCount;
        team_core_tokens[_addr].secondPhaseCount = 0;
      }

      if (now > team_core_tokens[_addr].thirdPhaseTime && now < team_core_tokens[_addr].fourPhaseTime) {
        if (_value <= team_core_tokens[_addr].thirdPhaseCount) {
          team_core_tokens[_addr].thirdPhaseCount = team_core_tokens[_addr].thirdPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        team_core_tokens[_addr].fourPhaseCount = team_core_tokens[_addr].fourPhaseCount + team_core_tokens[_addr].thirdPhaseCount;
        team_core_tokens[_addr].thirdPhaseCount = 0;
      }

      if (now > team_core_tokens[_addr].fourPhaseTime) {
        if (_value <= team_core_tokens[_addr].fourPhaseCount) {
          team_core_tokens[_addr].fourPhaseCount = team_core_tokens[_addr].fourPhaseCount - _value;
        } else {
          revert();
        }
      }
    }
    //-----------------------------------------------------//

    //for PE Investors
    //-----------------------------------------------------//

    isPE = findAddress(pe_investors_addresses, _addr);

    if (isPE) {
      if (now > pe_investors_tokens[_addr].firstPhaseTime && now < pe_investors_tokens[_addr].secondPhaseTime) {
        if (_value <= pe_investors_tokens[_addr].firstPhaseCount) {
          pe_investors_tokens[_addr].firstPhaseCount = pe_investors_tokens[_addr].firstPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        pe_investors_tokens[_addr].secondPhaseCount = pe_investors_tokens[_addr].secondPhaseCount + pe_investors_tokens[_addr].firstPhaseCount;
        pe_investors_tokens[_addr].firstPhaseCount = 0;
      }

      if (now > pe_investors_tokens[_addr].secondPhaseTime && now < pe_investors_tokens[_addr].thirdPhaseTime) {
        if (_value <= pe_investors_tokens[_addr].secondPhaseCount) {
          pe_investors_tokens[_addr].secondPhaseCount = pe_investors_tokens[_addr].secondPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        pe_investors_tokens[_addr].thirdPhaseCount = pe_investors_tokens[_addr].thirdPhaseCount + pe_investors_tokens[_addr].secondPhaseCount;
        pe_investors_tokens[_addr].secondPhaseCount = 0;
      }

      if (now > pe_investors_tokens[_addr].thirdPhaseTime && now < pe_investors_tokens[_addr].fourPhaseTime) {
        if (_value <= pe_investors_tokens[_addr].thirdPhaseCount) {
          pe_investors_tokens[_addr].thirdPhaseCount = pe_investors_tokens[_addr].thirdPhaseCount - _value;
        } else {
          revert();
        }
      } else {
        pe_investors_tokens[_addr].fourPhaseCount = pe_investors_tokens[_addr].fourPhaseCount + pe_investors_tokens[_addr].thirdPhaseCount;
        pe_investors_tokens[_addr].thirdPhaseCount = 0;
      }

      if (now > pe_investors_tokens[_addr].fourPhaseTime) {
        if (_value <= pe_investors_tokens[_addr].fourPhaseCount) {
          pe_investors_tokens[_addr].fourPhaseCount = pe_investors_tokens[_addr].fourPhaseCount - _value;
        } else {
          revert();
        }
      }
    }
    //-----------------------------------------------------//


  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(balances[msg.sender] >= _value);
    isFreeze(msg.sender, _value);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function newTransfer(address _from, address _to, uint256 _value) internal returns (bool) {
    require(balances[_from] >= _value);
    isFreeze(_from, _value);
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(_from, _to, _value);
    return true;
  }
 
  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
  }

  function findAddress(address[] _addresses, address _addr) private returns(bool) {
    for (uint256 i = 0; i < _addresses.length; i++) {
      if (_addresses[i] == _addr) {
        return true;
      }
    }
    return false;
  }
 
}
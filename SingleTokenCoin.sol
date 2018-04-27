pragma solidity ^0.4.15;

import "./MintableToken.sol";

contract SingleTokenCoin is MintableToken {
    
    string public constant name = "ADD Token";
    
    string public constant symbol = "ADD";
    
    uint32 public constant decimals = 18;
    
}
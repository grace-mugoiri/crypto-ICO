pragma solidity ^0.4.21;

contract ICO {
    string public name;
    string public symbol;
    uint public decimals;
    uint public bonusEnds;
    uint public icoEnds;
    uint public icoStarts;
    uint public allContributors;
    uint allTokens;
    address admin;
    mapping (address => uint) public balances;

    function ICO () public {
        name = "demoCoin";
        decimals = 18;
        symbol = "DC";
        bonusEnds = now + 2 weeks;
        icoEnds = now + 4 weeks;
        icoStarts = now;
        allTokens = 100;
        admin = (msg.sender);
        balances(msg.sender) = allToken;
    }
}
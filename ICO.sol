pragma solidity ^0.4.21;

 contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
     function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
 } 

 contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
 
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

contract ICO is ERC20Interface, SafeMath {
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
    mapping (address => mapping(address => uint)) allowed;

    constructor() public {
        using SafeMath for uint;

        name = "Gemini";
        decimals = 5;
        symbol = "GMN";
        bonusEnds = now + 2 weeks;
        icoEnds = now + 4 weeks;
        icoStarts = now;
        allTokens = 100;
        admin = (msg.sender);
        balances[msg.sender] = allTokens;
    }
    
    function buyTokens() public payable {
        uint tokens;

        if (now <= bonusEnds) {
            tokens  = msg.sender.safeMul(125);
        } else {
            tokens = msg.value.safeMul(100);
        }

        balances[msg.sender] = balances[msg.sender].add(tokens);
        allTokens = allTokens.add(tokens);
        Transfer(address(0), msg.sender, tokens);
        allContributors++;
    }
    
    function totalSupply() public constant returns(uint) {
        return allTokens;
    }


    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

   function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function myBalance() public constant returns (uint) {
        return (balances[msg.sender]);
    }
    
    function myAddress() public constant returns (address) {
        address myAdd = msg.sender;
        return myAdd;
    }
    
    function endSale() public {
        require(msg.sender == admin);
        admin.transfer(address(this).balance);
    }

    function ApproveAndCall(address spender, address tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    function () public payable {
        revert();
    }
}



// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./IERC20.sol";
//  is IERC20
contract ERC20 is IERC20 {
    address owner;
    uint totalTokens;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string _name;
    string _symbol;

    function name() external view returns (string memory){
        return _name;
    }

    function symbol() external view returns (string memory){
        return _symbol;
    }

    function decimals() external pure returns(uint){
        return 18;
    }

    function totalSupply() external view returns(uint){
        return totalTokens;
    }

    function balanceOf(address account) public  view returns(uint){
        return balances[account];
    }

    function transfer(address to, uint amount) external enoughTokens(msg.sender, amount){
       _beforeTokensTransfer(msg.sender, to, amount);
       balances[msg.sender] -= amount;
       balances[to] += amount;
       emit Transfer(msg.sender, to, amount);
    }

    function burn(address _from, uint amount) public onlyOwner {
        _beforeTokensTransfer(_from, address(0), amount);
        balances[_from] -= amount;
        totalTokens -= amount;
    }

    function _beforeTokensTransfer(address from, address to, uint amount) internal virtual{}

    function allowance(address _owner, address spender) public  view returns(uint){
        return allowances[_owner][spender];
    }

    function approve(address spender, uint amount) public {
        _approve(msg.sender, spender, amount);
       
    }

    function _approve(address sender, address spender, uint amount) internal virtual{
        allowances[msg.sender][spender] = amount;
        emit Approve(sender, spender, amount);
    }

    function transferFrom(address from, address to, uint amount) public  enoughTokens(from, amount){
        _beforeTokensTransfer(from, to, amount);
        require(allowances[from][to] >= amount, "you are not allowed to transfer this amount check allowences");
        allowances[from][to] -= amount;

        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
    }


    modifier enoughTokens(address from, uint amount){
        require(balanceOf(from) >= amount, "Not enough tokens to send");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You arent permitted to do this");
        _;
    }

    constructor(string memory name_, string memory symbol_, uint initialSupply, address shop){
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function mint(uint amount, address shop) public onlyOwner{
        _beforeTokensTransfer(address(0), shop, amount);
        balances[shop] += amount;
        totalTokens += amount;
        emit Transfer(address(0), shop, amount);

    }

   
}
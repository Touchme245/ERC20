// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./ERC.sol";

contract KuertovToken is ERC20{
    constructor(address shop) ERC20("KuertovToken", "KUT", 1000, shop) {}

}


contract KuertovShop{
    IERC20 public token;
    address payable public owner;

    event  Bought(uint amount, address indexed buyer);
    event Sold(uint amount, address seller);

    modifier onlyOwner(){
        require(msg.sender == owner, "you arent owner");
        _;
    }

    constructor(){
        token = new KuertovToken(address(this));
        owner = payable (msg.sender);
    }

    receive() external payable {
        uint tokensToBuy = msg.value; //1 wei = 1 token
        require(tokensToBuy >= 0, "not enough funds");

        require(tokenBalance() >= tokensToBuy, "not enough tokens");

        token.transfer(msg.sender, tokensToBuy);

        emit Bought(tokensToBuy, msg.sender);


    }

    function sell(uint amount) external {
        require(amount > 0 && token.balanceOf(msg.sender) >= amount, "incorrect ammount");
        
        uint allowence = token.allowance(msg.sender, address(this));
        require(allowence >= amount, "check allowens");
        token.transferFrom(msg.sender, address(this), amount);

        payable(msg.sender).transfer(amount);

        emit Sold(amount, msg.sender);
    }

    function tokenBalance() public view returns(uint){
        return token.balanceOf(address(this));
    }

    function aithdrawAll() external onlyOwner{
        owner.transfer(address(this).balance);
    }

}
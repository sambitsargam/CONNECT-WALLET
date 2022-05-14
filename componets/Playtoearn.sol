// SPDX-License-Identifier: MIT
    ////////////////////////////////////////////////////////////////////////
    // PlaytoEarn Smart contract
    /////////////////////////////////////////////////////////////////////////
    /**
     * @dev Admin function to set the contract.
     * Block & unblock Users
     * Send Reward token to Winner

     * Rules for player:
     * Will Start from joinit Function
     * Will check the balance of the user
     * Can clam/Withdraw the token to any wallet
     **/


pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract JoinGame {
    address public admin;
    uint256 public balance;
    address public player;
    mapping(address=> bool) isBlacklisted;
    
    event TransferReceived(address _from, uint _amount);
    event TransferSent(address _from, address _destAddr, uint _amount);
    
    constructor() public
    {
        admin = msg.sender;
    }

    function joinit() public
    {
        player = msg.sender;
    }


    //user is not allowed to do any thing with the token
    function blacklisted (address _user) external onlyAdmin()
    {
        require(!isBlacklisted[_user],"user is already blacklisted");
        isBlacklisted[_user] = true;  
    }
    
    //Remove someone 
    function removeFromBlacklist(address _user) external onlyAdmin(){
      require(isBlacklisted[_user],"use is already whitelisted");
      isBlacklisted[_user] = false;
    }
    modifier onlyAdmin() {
        require(msg.sender == admin, 'only admin');
        _;
    }

    function transferERC20(IERC20 token, address to, uint256 amount) public {         ///On winning you will call this function and send the specifc ammount
        require(msg.sender == admin, "Only owner can withdraw funds"); 
        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "balance is low");
        token.transfer(to, amount);
        emit TransferSent(msg.sender, to, amount);
    }  

    //Player part of the smart contract 
    function balanceOf() public view returns(uint256){
        return player.balance;
    }

    function withdraw(uint amount, address payable destAddr) public{               
        require(msg.sender == player || msg.sender == admin , "Only owner and player can withdraw funds"); 
        require(amount <= balance, "Insufficient funds");
        destAddr.transfer(amount);
        balance -= amount;
        emit TransferSent(msg.sender, destAddr, amount);
    }
   
}
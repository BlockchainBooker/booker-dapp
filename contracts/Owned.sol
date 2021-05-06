  
pragma solidity ^0.8.0;

contract Owned {
  // State variables
  address owner;

  //modifiers
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  // constructor
  function isOwned() public{
    owner = msg.sender;
  }


}
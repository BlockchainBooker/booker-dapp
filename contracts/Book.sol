pragma solidity ^0.8.0;

import './Owned.sol';
 
contract Book is Owned{

    string private title;
    string private author;
    uint private year;
    uint private price;
    address seller;
    address buyer;

    constructor(string memory _title, string memory _author, uint _year, uint _price) {
        title = _title;
        author = _author;
        year = _year; 
        price = _price;
        seller = msg.sender;
    }

    function setTitle (string memory newT) public{
        title = newT;
    }

    function getTitle() public view returns (string memory)  {
        return title;
    }

     function setAuthor (string memory newA) public{
        author = newA;
    }

    function getAuthor() public view returns (string memory)  {
     return author;
    }

     function setYear (uint newY) public{
        year = newY;
    }

    function getYear() public view returns (uint)  {
        return year;
    }

    function setPrice (uint newP) public{
        price = newP;
    }

    function getPrice() public view returns (uint)  {
        return price;
    }

    function getSeller() public view returns (address)  {
        return seller;
    }
}
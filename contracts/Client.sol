pragma solidity ^0.8.0;
 
import './Book.sol';
 
contract Client{
    
    Book[] public books;
    string private name;
    

    constructor( string memory _name ) public{
        name = _name;
    }

    // modifier onlyOwner (){
    //     require(msg.sender == owner);
    //     _;
    // }

    function setName(string memory newN) public{
       name  = newN;
    }

    function getName() public view returns (string memory)  {
        return name;
    }

    function addBook(Book book) public
    {
        books.push(book);
    }

    function publishBook(uint _id) public
    {
        delete(books[_id]);
    }

}
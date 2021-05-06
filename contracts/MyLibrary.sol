// pragma solidity >=0.4.21 <0.7.0;
pragma solidity ^0.8.0;

import "./Book.sol";
import "./Client.sol";

contract MyLibrary {
    mapping(address => Client) public clients;
    mapping(uint256 => Book) public libraryBooks;
    uint256 nrBooks = 0;

    // struct ClientBook{
    //     Client client;
    //     Book book[];
    // }
    // ClientBook[] public clientBooks;
    // mapping(Client => mapping(uint => Book)) public clientBooks;

    //uint[] public books;

    constructor() public {
        // books.push(0);
        // value = "myValue";
        // clients[clients.length] = clientName;
    }

    function addBook(
        string memory _title,
        string memory _author,
        uint256 _year,
        uint256 _price
    ) public returns (Book, uint256) {
        // libraryBooks[_id].push(new Book( _title, _author, _year, _price));
        Book temp = new Book(_title, _author, _year, _price);
        libraryBooks[nrBooks] = temp;
        nrBooks++;
        return (temp, nrBooks);
    }

    function addClient(
        uint256 _id,
        string memory _title,
        string memory _author,
        uint256 _year,
        uint256 _price
    ) public {
        // libraryBooks[_id].push(new Book( _title, _author, _year, _price));
        libraryBooks[_id] = new Book(_title, _author, _year, _price);
    }

    modifier exists(uint256 _id) {
        require(nrBooks < _id, "The book does not exist.");
        _;
    }

    modifier costs(address buyer, uint256 _amount) {
        require(buyer.balance <= _amount, "Not enough Ether provided.");
        _;
    }

    // function buyBook(uint256 _id, address payable buyer)
    //     public
    //     payable
    //     costs(buyer, libraryBooks[_id].getPrice())
    //     exists(_id)
    // {
    //     address seller = libraryBooks[_id].getSeller();
    //     buyer.transfer(libraryBooks[_id].getPrice());
    //     clients[buyer].addBook(libraryBooks[_id]);
    //     delete (libraryBooks[_id]);
    //     nrBooks--;
    // }

    function getBooks() public view returns (Book[] memory) {
        Book[] memory temp = new Book[](nrBooks);

        for (uint256 i = 0; i < nrBooks; i++) {
            temp[i] = libraryBooks[i];
        }

        return temp;
    }

    function getRandom() public pure returns (string memory) {
        return "test";
    }

    // function setName (string memory newName) public{
    // MyContract.deployed().then((instance) => { app = instance } )ame = newName;
    // }

    // function getName() public view returns (string memory)  {
    // return name;
    // }

    // function setAge (uint newAge) public{
    //     age = newAge;
    // }

    // function getAge() public view returns (uint) {
    //     return age;
    // }

    // function get() public view returns(string memory) {
    //     return value;
    // }

    // function set(string memory _value) public {
    //     value = _value;
    // }
}

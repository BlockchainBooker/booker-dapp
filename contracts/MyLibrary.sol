// pragma solidity >=0.4.21 <0.7.0;
pragma solidity ^0.8.0;

import './Book.sol';
import './Client.sol';

contract MyLibrary{

    mapping(address => Client) public clients;
    mapping(uint => Book) public libraryBooks;
    uint nrBooks = 0;

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

    function addBook(uint _id, string memory _title, string memory _author, uint _year, uint _price) public {

        // libraryBooks[_id].push(new Book( _title, _author, _year, _price));
        libraryBooks[_id] = new Book( _title, _author, _year, _price);
        nrBooks ++;
    }

    function addClient(uint _id, string memory _title, string memory _author, uint _year, uint _price) public {

        // libraryBooks[_id].push(new Book( _title, _author, _year, _price));
        libraryBooks[_id] = new Book( _title, _author, _year, _price);
    }


    modifier exists(uint _id) {
    require(nrBooks < _id , "The book does not exist.");
    _;
    }

    modifier costs(address buyer, uint _amount) {
    require(buyer.balance <= _amount, "Not enough Ether provided.");
    _;
    }

    function buyBook(uint _id, address payable buyer) public payable costs(buyer, libraryBooks[_id].getPrice()) exists(_id) {
        address seller = libraryBooks[_id].getSeller();
        buyer.transfer(libraryBooks[_id].getPrice());
        clients[buyer].addBook(libraryBooks[_id]);
        delete(libraryBooks[_id]);
        nrBooks --;
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
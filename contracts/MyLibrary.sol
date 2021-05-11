// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Owned.sol";

contract MyLibrary is Owned {
    mapping(address => Customer) public customers;
    mapping(string => Book) public books;
    string[] public booksIds;

    struct Customer {
        address adr;
        string[] ownedBooks;
    }

    struct Book {
        string id;
        string name;
        string author;
        uint256 price;
        uint256 default_amount;
    }

    event CustomerRegistered(address customer);
    event CustomerRegistrationFailed(address customer);

    event BookBuyCompleted(address customer, string bookId);
    event BookBuyFailed(address customer, string bookId);

    event BookRegistered(string bookId);
    event BookDeregistered(string bookId);
    event BookRegisteredFailed(string productId);
    event BookDeregistrationFaled(string productId);

    constructor() {
        owner = msg.sender;
    }

    function addBook(
        string memory id,
        string memory name,
        string memory author,
        uint256 price,
        uint256 default_amount
    ) public onlyOwner returns (bool success) {
        Book memory book = Book(id, name, author, price, default_amount);
        if (checkProductValidity(book)) {
            books[id] = book;
            booksIds.push(id);
            emit BookRegistered(id);
            return true;
        }
        emit BookRegisteredFailed(id);
        return false;
    }

    function deleteBook(string memory id)
        public
        onlyOwner
        returns (bool success)
    {
        Book memory product = books[id];
        if (compareStrings(product.id, id)) {
            delete books[id];
            emit BookDeregistered(id);
            return true;
        }
        emit BookDeregistrationFaled(id);
        return false;
    }

    function registerCustomer(address _address, string calldata bookId)
        private
        returns (bool success)
    {
        if (_address != address(0)) {
            Customer memory customer =
                Customer({adr: _address, ownedBooks: new string[](0)});
            customers[_address] = customer;
            customers[_address].ownedBooks.push(bookId);
            emit CustomerRegistered(_address);
            return true;
        }
        emit CustomerRegistrationFailed(_address);
        return false;
    }

    function getOwnedBooks()
        public
        view
        returns (bool exists, string[] memory ownedBooks)
    {
        if (customers[msg.sender].adr != address(0)) {
            // exista deja
            return (true, customers[msg.sender].ownedBooks);
        }
        return (false, customers[msg.sender].ownedBooks);
    }

    function buyBook(string calldata id)
        public
        payable
        returns (
            bool success,
            uint256 aft,
            uint256 before,
            Customer memory cust
        )
    {
        if (books[id].default_amount > 0) {
            before = books[id].default_amount;
            books[id].default_amount--;

            if (customers[msg.sender].adr != address(0)) {
                // exista deja
                registerCustomer(msg.sender, id);
            } else {
                customers[msg.sender].ownedBooks.push(id);
            }

            emit BookBuyCompleted(msg.sender, id);
            return (
                true,
                books[id].default_amount,
                before,
                customers[msg.sender]
            );
        }
        emit BookBuyFailed(msg.sender, id);
        return (false, 0, 0, customers[msg.sender]);
    }

    function getBook(string memory id)
        public
        view
        returns (
            string memory name,
            string memory author,
            uint256 price,
            uint256 default_amount
        )
    {
        return (
            books[id].name,
            books[id].author,
            books[id].price,
            books[id].default_amount
        );
    }

    // function getCart()
    //     public
    //     returns (uint256[] memory product_ids, uint256 complete_sum)
    // {
    //     Customer customer = customers[msg.sender];
    //     uint256 len = customer.cart.products.length;
    //     uint256[] memory ids = new uint256[](len);
    //     for (uint256 i = 0; i < len; i++) {
    //         ids[i] = products[i].id;
    //     }
    //     return (ids, customer.cart.completeSum);
    // }

    modifier costs(address buyer, uint256 _amount) {
        require(buyer.balance <= _amount, "Not enough Ether provided.");
        _;
    }

    function getRandom() public pure returns (string memory) {
        return "test";
    }

    function checkProductValidity(Book memory book)
        private
        pure
        returns (bool valid)
    {
        return (book.price > 0);
    }

    function getBooksCount() public view returns (uint256 count) {
        return booksIds.length;
    }

    function compareStrings(string memory a, string memory b)
        public
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}

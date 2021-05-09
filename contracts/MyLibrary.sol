// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Owned.sol";

contract MyLibrary is Owned {
    mapping(address => Customer) customers;
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

    function registerCustomer(address _address) private returns (bool success) {
        if (_address != address(0)) {
            Customer memory customer =
                Customer({adr: _address, ownedBooks: new string[](0)});
            customers[_address] = customer;
            emit CustomerRegistered(_address);
            return true;
        }
        emit CustomerRegistrationFailed(_address);
        return false;
    }

    function getMyProfile()
        public
        returns (address adr, string[] memory ownedBooks)
    {
        if (customers[msg.sender].adr != address(0)) {
            // exista deja
            return (
                customers[msg.sender].adr,
                customers[msg.sender].ownedBooks
            );
        } else {
            if (registerCustomer(msg.sender)) {
                return (
                    customers[msg.sender].adr,
                    customers[msg.sender].ownedBooks
                );
            }
        }
    }

    // function insertProductIntoCart(uint256 id)
    //     returns (bool success, uint256 pos_in_prod_mapping)
    // {
    //     Customer cust = customers[msg.sender];
    //     Product prod = products[id];
    //     uint256 prods_prev_len = cust.cart.products.length;
    //     cust.cart.products.push(prod.id);
    //     uint256 current_sum = cust.cart.completeSum;
    //     cust.cart.completeSum = safeAdd(current_sum, prod.price);
    //     if (cust.cart.products.length > prods_prev_len) {
    //         CartProductInserted(
    //             msg.sender,
    //             id,
    //             prod.price,
    //             cust.cart.completeSum
    //         );
    //         return (true, cust.cart.products.length - 1);
    //     }
    //     CartProductInsertionFailed(msg.sender, id);
    //     return (false, 0);
    // }

    // function checkoutCart() returns (bool success) {
    //     Customer customer = customers[msg.sender];
    //     uint256 paymentSum = customer.cart.completeSum;
    //     if (
    //         (customer.balance >= paymentSum) &&
    //         customer.cart.products.length > 0
    //     ) {
    //         customer.balance -= paymentSum;
    //         customer.cart = Cart(new uint256[](0), 0);
    //         store_balance += paymentSum;
    //         CartCheckoutCompleted(msg.sender, paymentSum);
    //         return true;
    //     }
    //     CartCheckoutFailed(msg.sender, customer.balance, paymentSum);
    //     return false;
    // }

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
        private
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}

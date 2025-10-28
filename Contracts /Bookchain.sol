// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BookChain
 * @dev A decentralized book ownership and publishing registry.
 *      Authors can register books, transfer ownership, and view book details.
 */
contract BookChain {
    // Struct to store book details
    struct Book {
        uint256 id;
        string title;
        string authorName;
        address owner;
        uint256 timestamp;
    }

    // State variables
    uint256 private bookCount;
    mapping(uint256 => Book) public books;

    // Events
    event BookRegistered(uint256 indexed bookId, string title, address indexed owner);
    event OwnershipTransferred(uint256 indexed bookId, address indexed oldOwner, address indexed newOwner);

    // Register a new book
    function registerBook(string memory _title, string memory _authorName) public {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_authorName).length > 0, "Author name cannot be empty");

        bookCount++;
        books[bookCount] = Book(bookCount, _title, _authorName, msg.sender, block.timestamp);

        emit BookRegistered(bookCount, _title, msg.sender);
    }

    // Transfer ownership of a book
    function transferOwnership(uint256 _bookId, address _newOwner) public {
        require(_bookId > 0 && _bookId <= bookCount, "Book does not exist");
        Book storage book = books[_bookId];
        require(msg.sender == book.owner, "You are not the owner");

        address oldOwner = book.owner;
        book.owner = _newOwner;

        emit OwnershipTransferred(_bookId, oldOwner, _newOwner);
    }

    // Get book details
    function getBook(uint256 _bookId) public view returns (Book memory) {
        require(_bookId > 0 && _bookId <= bookCount, "Book does not exist");
        return books[_bookId];
    }

    // Get total number of books
    function getTotalBooks() public view returns (uint256) {
        return bookCount;
    }
}

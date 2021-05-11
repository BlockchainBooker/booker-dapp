var MyLibrary = artifacts.require("./MyLibrary.sol");
contract("MyLibrary", (accounts) => {
  it("check getBooksCount() function", async () => {
    MyLibrary = await MyLibrary.deployed();
    var number = await MyLibrary.getBooksCount();
    assert.equal(number, MyLibrary.booksIds.length);
  });
  it("check addBook() function", async () => {
    var number = await MyLibrary.getBooksCount();
    MyLibrary.addBook("1", "TITLU", "AUTOR", 2011, 10);
    var newNumber = await MyLibrary.getBooksCount();
    assert.equal(newNumber, parseInt(number) + 1);
  });
  it("check compareStrings() function", async () => {
    let check = await MyLibrary.compareStrings("test", "test");
    assert.isTrue(check, "");
  });
});

var MyContract = artifacts.require("./MyLibrary.sol");

module.exports = function(deployer) {
  deployer.deploy(MyLibrary);
};

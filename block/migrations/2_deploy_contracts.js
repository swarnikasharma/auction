var Auctioneer = artifacts.require("./Auction.sol");

module.exports = function(deployer) {
  deployer.deploy(Auctioneer,19,15);
};

//Ignore the error below
// eslint-disable-next-line no-undef
const Kryptobird = artifacts.require("Kryptobird");

module.exports = function (deployer) {
  deployer.deploy(Kryptobird);
};

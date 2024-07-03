const CMS = artifacts.require("CMS");

module.exports = function (_deployer) {
  _deployer.deploy(CMS, "0xE33d4662AbC788e1842640C71C2c6F29A7f8046b");
};

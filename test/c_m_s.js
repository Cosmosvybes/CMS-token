const CMS = artifacts.require("CMS");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("CMS", function (/* accounts */) {
  it("should assert business name CMS", async function () {
    const cms = await CMS.deployed();
    const business_name = await cms.business_name();
    assert(
      business_name.toString() == "COSMOS TOKEN",
      "business name is not CMS"
    );
  });

  it("should return initial token balance in the director's wallet", async function () {
    const cms = await CMS.deployed();
    const total_Shares = await cms._totalShares();
    const owner_balance = await cms.balanceOf(
      "0xE33d4662AbC788e1842640C71C2c6F29A7f8046b"
    );
    assert(owner_balance.toString() == "1000", "initial balance is not 1000");
  });
});

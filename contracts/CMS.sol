// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/utils/math/Math.sol";
import "./Auth/_Auth.sol";

contract CMS is Auth {
    struct new_admin {
        bool isAllowed;
        address admin;
    }

    mapping(address => mapping(address => new_admin)) administrators;

    event Purchase(address _buyer, uint256 amount);

    uint256 decimals = 15;
    uint256 public _totalShares = 1000;
    string public business_name;
    uint256 private memberSharesLimit = 100;
    uint256 private shareHolderLimit = 500;
    address payable public _owner;
    address private _director;
    mapping(address => uint256) private balances;

    struct member {
        address identity;
        string name;
        bool isShareHolder;
        bool onboarded;
    }

    mapping(address => member) public members;
    mapping(address token => mapping(address => bool)) _CMSAddress;

    constructor(address payable _address) Auth(_address) {
        business_name = "COSMOS TOKEN";
        _owner = _address;
        balances[_owner] += _totalShares;
        members[_owner] = member({
            identity: _owner,
            name: "Director",
            isShareHolder: true,
            onboarded: true
        });

        administrators[_owner][_owner] = new_admin({
            isAllowed: true,
            admin: _owner
        });
    }

    function balanceOf(address _address) public view returns (uint256 balance) {
        return balances[_address];
    }

    modifier isAdmin() {
        require(
            administrators[_owner][msg.sender].isAllowed == true,
            "Permission denied"
        );
        _;
    }

    //?? @dev  this function adds new customer and sign a COSMOS TOKEN wallet to tthe user
    function onboard(
        address _user_address,
        string memory _user_name
    ) public isAdmin returns (member memory) {
        _CMSAddress[_owner][_user_address] = true;
        return
            members[_user_address] = member({
                identity: _user_address,
                name: _user_name,
                isShareHolder: false,
                onboarded: true
            });
    }

    modifier fromDirector() {
        require(msg.sender == _director, "Permission denied");
        _;
    }

    function permit(
        address _address
    ) public fromDirector returns (bool status) {
        administrators[_owner][_address].isAllowed = true;
        return true;
    }

    modifier isMember(address _address) {
        require(
            members[_address].onboarded == true,
            "Access denied, not a member"
        );
        _;
    }

    function buy(
        address _user
    ) public payable isMember(_user) returns (bool success) {
        require(
            balances[_user] < memberSharesLimit,
            "buying limit has reached"
        );
        uint256 sharesAmount = msg.value / 10 / 10 ** decimals;
        require(
            sharesAmount <= memberSharesLimit &&
                (balances[_user] + sharesAmount) <= memberSharesLimit,
            "As a member you can only buy A hundred shares."
        );

        assert(msg.sender.balance > 10 ** 18);
        balances[_owner] = balances[_owner] - sharesAmount;
        _owner.transfer(msg.value);
        balances[_user] = balances[_user] + sharesAmount;
        emit Purchase(_user, sharesAmount);
        return true;
    }

    function checkPermission(address _user) public view returns (bool) {
        return administrators[_owner][_user].isAllowed;
    }

    function mint(
        address _address
    ) public isMember(_address) returns (uint256) {
        return balances[_address] = balances[_address] + 1;
    }

    modifier hasEnoughToken(uint256 _amount) {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        _;
    }

    modifier onlyToCMSAddress(address _address) {
        require(_CMSAddress[_owner][_address] == true, "Invalid CMSTK address");
        _;
    }

    function transfer(
        address _from,
        address _to,
        uint256 amount
    )
        public
        onlyToCMSAddress(_to)
        hasEnoughToken(amount)
        returns (bool success)
    {
        balances[_from] -= amount;
        balances[_to] += amount;
        return true;
    }
}

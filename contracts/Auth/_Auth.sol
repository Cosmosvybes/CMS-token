// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Auth {
    address private _owner;

    struct admin_ {
        bool isAllowed;
        address admin;
    }

    mapping(address => mapping(address => admin_)) public _admins;

    constructor(address _isAdmin) public {
        _owner = _isAdmin;

        _admins[_owner][_isAdmin] = admin_({isAllowed: true, admin: _owner});
    }

    modifier _isDirector() virtual {
        require(msg.sender == _owner, "Access denied");
        _;
    }
    function createAccess(
        address _newAdmin
    ) public _isDirector returns (bool success) {
        _admins[_owner][_newAdmin] = admin_({
            isAllowed: true,
            admin: _newAdmin
        });
        return true;
    }

    function restrict(address _admin) public _isDirector returns (bool) {
        return _admins[_owner][_admin].isAllowed = false;
    }

    function readAdmin(
        address _user_address
    ) public view _isDirector returns (admin_ memory) {
        return _admins[_owner][_user_address];
    }
}

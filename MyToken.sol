// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ERC20Token {
    string public name;
    mapping(address => uint256) public balances;

    constructor (string memory _name) {
        name = _name;
    }

    function mint () virtual public {
        balances[tx.origin] += 1;
    }
}

contract MyToken is ERC20Token {
    address[] public owners;
    uint256 public ownerCount;
    string public symbol;

    constructor (string memory _name, string memory _symbol) ERC20Token(_name) {
        symbol = _symbol;
    }

    function mint () public override {
        super.mint();
        ownerCount ++;
        owners.push(msg.sender);
    }
}
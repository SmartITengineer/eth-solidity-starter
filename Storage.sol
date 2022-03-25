// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Storage {
    enum State { Waiting, Ready, Active }

    struct Person {
        uint id;
        string _firstName;
        string _lastName;
    }

    event personAdded(
        uint indexed id,
        string _firstName,
        string _lastName
    );

    event Purchase(
        address _buyer,
        uint256 _amount
    );

    address owner;
    address payable wallet;
    State public state;
    uint256 startTime;
    // Person[] public people;
    mapping(uint => Person) public people;
    mapping(address => uint256) public balances;
    string public constant value = "myValue";
    uint256 public peopleCount = 0;

    constructor (address payable _wallet) {
        owner = msg.sender;
        wallet = _wallet;
        state = State.Waiting;
        startTime = 1648247333;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyWhileOpen () {
        require(block.timestamp >= startTime, 'Old Block');
        _;
    }

    function activate () public {
        state = State.Active;
    }

    function isActive () public view returns (bool) {
        return state == State.Active;
    }

    function addPerson (string memory _firstName, string memory _lastName) public onlyWhileOpen {
        incrementCount();
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);

        emit personAdded(peopleCount, _firstName, _lastName);
    }

    function incrementCount () internal {
        peopleCount += 1;
    }

    function buyToken (uint _amount) public payable {
        balances[msg.sender] += _amount;
        wallet.transfer(msg.value);

        emit Purchase(msg.sender, _amount);
    }

    fallback () external payable {
        buyToken(1);
    }

    receive () external payable {
        
    }
}
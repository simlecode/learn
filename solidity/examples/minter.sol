// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

contract coin {
    // public: function minter() external view returns (address) { return minter; }
    address public minter;
    // public: function balances(address account) external view returns (uint) { return balances[account]; }

    mapping(address => uint) public balances;

    event Send(address from, address to,uint amount);

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(minter==msg.sender);
        balances[receiver] += amount;
    }

    error InsufficientBalance(uint requested, uint avaliable);

    function send(address receiver , uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                avaliable: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        emit Send(msg.sender, receiver, amount);
    }
}
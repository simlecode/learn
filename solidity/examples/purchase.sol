// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.17;

contract Purchase {
    uint public value;
    address payable public seller;
    address payable public buyer;

    enum State { Created, Locked, Release, Inactive }
    // The state variable has a default value of the first member, `State.created`
    State public state;

    event Abourted();
    event ConfirmPurchase();
    event ItemReceived();
    event SellerRefuned();

    /// The provided value has to be even.
    error ValueNotEven();
    error OnlyBuyer();
    error OnlySeller();
    error InvalidState();

    modifier condition(bool condition_) {
        require(condition_);
        _;
    }

    modifier onlyBuyer() {
        if (msg.sender != buyer)
            revert OnlyBuyer();
        _;
    }

    modifier onlySeller() {
        if (msg.sender != seller)
            revert OnlySeller();
        _;
    }

    modifier isState(State state_) {
        if (state != state_)
            revert InvalidState();
        _;
    }

    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;
        if (value * 2 != msg.value)
            revert ValueNotEven();
    }

    function abourt() 
        external 
        onlySeller 
        isState(State.Created) 
    {
        emit Abourted();
        state = State.Inactive;
        // We use transfer here directly. It is
        // reentrancy-safe, because it is the
        // last call in this function and we
        // already changed the state.
        // seller.transfer(address(this).balances);
    }

    function confirmPurchase() 
        external
        isState(State.Created)
        onlyBuyer
        condition(msg.value == 2 * value)
        payable
    {
        emit ConfirmPurchase();
        buyer = payable(msg.sender);
        state = State.Locked;
    }

    function confirmReceive() 
        external
        isState(State.Locked)
        onlyBuyer
    {
        emit ItemReceived();
        state = State.Release;
        buyer.transfer(value);
    }

    function refundSeller() 
        external
        onlySeller
        isState(State.Release)
    {
        emit SellerRefuned();
        state = State.Inactive;
        seller.transfer(3 * value);
    }
}
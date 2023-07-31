// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.17;

contract BlindAuction {
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    address payable public beneficiary;

    mapping(address => Bid[]) bids;

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    uint biddingEnd;
    uint revealEnd;
    
    address highestBidder;
    uint highestBid;

    bool ended;

    error TooEarly(uint time);
    error TooLate(uint time);
    error AuctionEndAlreadyCalled();

    event AuctionEnded(address bidder, uint amount);

    modifier onlyBefore(uint time) {
        if (block.timestamp >= time) revert TooLate(time);
        _;
    }

    modifier onlyAfter(uint time) {
        if (block.timestamp <= time) revert TooEarly(time);
        _;
    }

    constructor(uint biddingTime, uint revealTime, address payable beneficiaryAddress) {
        biddingEnd = block.timestamp + biddingTime;
        revealEnd = biddingEnd + revealTime;
        beneficiary = beneficiaryAddress;
    }

    function bid(bytes32 blindedBid) external payable onlyBefore(biddingEnd) {
        bids[msg.sender].push(Bid({
            blindedBid: blindedBid,
            deposit: msg.value
        }));
    }

    function reveal(
        uint[] calldata values,
        bool[] calldata fakes,
        bytes32[] calldata secrets
    ) 
        external
        onlyBefore(revealEnd)
        onlyAfter(biddingEnd)
    {
        uint length = bids[msg.sender].length;
        require(values.length == length);
        require(fakes.length == length);
        require(secrets.length == length);

        uint refund;
        for (uint i = 0; i < length; i++) {
            Bid storage bidToCheck = bids[msg.sender][i];

            (uint value, bool fake, bytes32 secret) = (values[i], fakes[i], secrets[i]);
            if (bidToCheck.blindedBid != keccak256(abi.encodePacked(value, fake, secret))) {
                continue;
            }

            refund += bidToCheck.deposit;
            if (!fake && bidToCheck.deposit >= value) {
                if (placeBid(msg.sender, value)) {
                    refund -= value;
                }
            }

            bidToCheck.deposit = 0;
        }

        payable(msg.sender).transfer(refund);
    }
   
    function withdraw() external {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            payable(msg.sender).transfer(amount);
        }
    }

    function auctionEnd() external onlyAfter(revealEnd) {
        if (ended) {
            revert AuctionEndAlreadyCalled(); 
        }

        emit AuctionEnded(highestBidder, highestBid);
        ended = true;
        beneficiary.transfer(highestBid);
    }

    function placeBid(address bidder, uint value) internal returns (bool success) {
        if (value < highestBid) {
            return false;
        }

        if (highestBidder != address(0)) {
            pendingReturns[bidder] += value;
        }

        highestBid = value;
        highestBidder = bidder;

        return true;
    }
}